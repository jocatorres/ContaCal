# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :cpf, :address_street_and_number, :address_city, :address_state, :address_zipcode, :kcal_limit, :subscribed_daily, :subscribed_weekly
  has_many :user_foods
  validates :name, :presence => true
  after_create :send_welcome_email
  scope :active, where(:deleted_at => nil)
  scope :subscribed_daily, active.where(:subscribed_daily => true)
  scope :subscribed_weekly, active.where(:subscribed_weekly => true)

  class << self
    def send_weekly_notification!
      run_on_each_subscribed_weekly { |user| NotificationMailer.weekly(user).deliver }
    end

    def send_beginning_of_day_notification!
      run_on_each_subscribed_daily { |user| NotificationMailer.beginning_of_day(user).deliver }
    end

    def send_end_of_day_notification!
      run_on_each_subscribed_daily { |user| NotificationMailer.end_of_day(user).deliver if user.deliver_end_of_day_email? }
    end

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

  def consumed_kcal(params = {})
    params[:date] ||= Date.today
    scope = user_foods.includes(:food).where(:date => params[:date])
    scope = scope.where(:meal => params[:meal]) unless params[:meal].nil?
    scope = scope.where('foods.kind = ?', params[:kind]) unless params[:kind].nil?
    scope.sum(:kcal).to_f
  end
  
  def consumed_foods(params = {})
    params[:date] ||= Date.today
    scope = user_foods.includes(:food).where(:date => params[:date])
    scope = scope.where(:meal => params[:meal]) unless params[:meal].nil?
    scope.order('user_foods.created_at DESC').all
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

  private
  def send_welcome_email
    NotificationMailer.welcome(self).deliver
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
end
