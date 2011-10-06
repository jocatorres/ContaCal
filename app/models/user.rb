# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :cpf, :address_street_and_number, :address_city, :address_state, :address_zipcode, :kcal_limit, :subscribed_daily, :subscribed_weekly
  has_many :user_foods
  validates :name, :presence => true
  scope :active, where(:deleted_at => nil)
  scope :subscribed_daily, active.where(:subscribed_daily => true)
  scope :subscribed_weekly, active.where(:subscribed_weekly => true)

  class << self
    def send_beginning_of_day_notification!
      run_on_each_subscribed { |user| NotificationMailer.beginning_of_day(user).deliver }
    end

    def send_end_of_day_notification!
      run_on_each_subscribed do |user|
        NotificationMailer.end_of_day(user).deliver if user.deliver_end_of_day_email?
      end
    end
    
    def run_on_each_subscribed
      subscribed_daily.each { |user| yield(user) }
    end
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

  private
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
