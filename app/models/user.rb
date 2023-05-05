# -*- encoding : utf-8 -*-
class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  ATTRIBUTES_ACCESSIBLE = [:name, :email, :password, :password_confirmation, :remember_me, :cpf, :address_street_and_number, :address_city, :address_state, :address_zipcode, :kcal_limit, :subscribed_daily, :subscribed_weekly, :nutri_name, :nutri_email, :referred_by_email, :subscribed_newsletter, :small_portions]
  
  has_many :user_foods
  has_many :user_weight
  has_many :user_friends
  validates :name, :presence => true
  # after_create :send_welcome_email
  scope :active, -> { where(:deleted_at => nil) }
  scope :subscribed_daily, -> { active.where(:subscribed_daily => true) }
  scope :subscribed_weekly, -> { active.where(:subscribed_weekly => true) }

  class << self
    def send_weekly_notification!
      run_on_each_subscribed_weekly { |user| NotificationMailer.weekly(user).deliver }
    end

    def send_beginning_of_day_notification!
      run_on_each_subscribed_daily { |user| NotificationMailer.beginning_of_day(user).deliver }
    end

    # def send_end_of_day_notification!
    #   run_on_each_subscribed_daily { |user| NotificationMailer.end_of_day(user).deliver if user.deliver_end_of_day_email? }
    # end

    def run_on_each_subscribed_weekly
      subscribed_weekly.each { |user| yield(user) }
    end

    def run_on_each_subscribed_daily
      subscribed_daily.each { |user| yield(user) }
    end
  end
  
  def update_with_password(params={})
    params.delete(:current_password)
    if params[:password].blank? 
      params.delete(:password) 
      params.delete(:password_confirmation) if params[:password_confirmation].blank? 
    end
    self.update_attributes(params)
  end
  
  def consumed_foods(params = {})
    scope = prepare_user_foods_scope(params, Food::Consumables)
    scope.order('user_foods.created_at DESC').all
  end

  def exercises(params = {})
    scope = prepare_user_foods_scope(params, Food::Expendables)
    scope.order('user_foods.created_at DESC').all
  end

  def foods_and_exercises(params = {})
    scope = prepare_user_foods_scope(params, Food::Consumables + Food::Expendables)
    scope.order('user_foods.created_at DESC').all
  end

  def consumed_kcal(params = {})
    scope = prepare_user_foods_scope(params, Food::Consumables)
    scope = scope.where('foods.kind = ?', params[:kind]) unless params[:kind].nil?
    scope.sum(:kcal).to_f
  end

  def spent_kcal(params = {})
    scope = prepare_user_foods_scope(params, Food::Expendables)
    scope = scope.where('foods.kind = ?', params[:kind]) unless params[:kind].nil?
    scope.sum(:kcal).to_f
  end
  
  def net_kcal(params = {})
    consumed_kcal(params) - spent_kcal(params)
  end
  
  def deliver_end_of_day_email?
    consumed_kcal_less_than_1000_kcal || consumed_kcal_less_than_70_percent
  end

  def destroy
    update_attribute(:deleted_at, Time.now)
  end
  
  def last_week_history
    return @last_weeek_history unless @last_weeek_history.nil?
    
    from = 7.days.ago.to_date
    to = 1.day.ago.to_date
    days = []
    (from..to).each do |date|
      kcal = consumed_kcal({:date => date})
      if kcal.zero?
        percent_kind_a = percent_kind_b = percent_kind_c = 0.0
      else
        percent_kind_a = (consumed_kcal({:date => date, :kind => 'a'})/kcal*100).round(2)
        percent_kind_b = (consumed_kcal({:date => date, :kind => 'b'})/kcal*100).round(2)
        percent_kind_c = (consumed_kcal({:date => date, :kind => 'c'})/kcal*100).round(2)
      end
      days << {
        :day => date,
        :kcal => kcal,
        :percent_kind_a => percent_kind_a,
        :percent_kind_b => percent_kind_b,
        :percent_kind_c => percent_kind_c,
      }
    end
    @last_weeek_history = {
      :from => from,
      :to => to,
      :days => days
    }
  end

  def display_current_weight(params)
    if (user_weight.find_by_date(params[:date].to_date).nil?)
      if (params[:tipo].to_s == 'str')
        "não informado"                 
      else
        0
      end
    else
      if (params[:tipo].to_s == 'str')
        "#{user_weight.find_by_date(params[:date].to_date).weight.to_f.to_s} Kg"
      else
        "#{user_weight.find_by_date(params[:date].to_date).weight.to_f.to_s}"
      end 
    end
  end

  private
  def send_welcome_email
    date_expire = Date.today+5
    NotificationMailer.welcome(self).deliver
  	update_attribute(:confirmed_at, Time.now)
		update_attribute(:confirmation_sent_at, Time.now)
  	update_attribute(:expire_at, date_expire.strftime("%Y-%m-%d"))
 	  update_attribute(:status, 10)
 	  update_attribute(:subscribed_daily, "t")
 	  update_attribute(:subscribed_weekly, "f")
 	  update_attribute(:small_portions, "f")
  end

  def consumed_kcal_less_than_1000_kcal
    (kcal_limit.blank? || kcal_limit.zero?) && (consumed_kcal_today < 1000)
  end
  def consumed_kcal_less_than_70_percent
    !kcal_limit.blank? && ((consumed_kcal_today/kcal_limit) < 0.7)
  end
  def consumed_kcal_today
    consumed_kcal(:date => Date.today)
  end

  def prepare_user_foods_scope(params, included_kinds)
    params[:date] ||= Date.today
    scope = user_foods.includes(:food).where(:date => params[:date])
    scope = scope.where(:meal => params[:meal]) unless params[:meal].nil?
    scope = scope.where(:foods => {:kind => included_kinds })
    scope
  end
end
