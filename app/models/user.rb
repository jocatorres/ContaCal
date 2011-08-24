# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :cpf, :address_street_and_number, :address_city, :address_state, :address_zipcode, :kcal_limit, :subscribed
  has_many :user_foods
  validates :name, :presence => true
  scope :subscribed, where(:subscribed => true)

  class << self
    def send_beginning_of_day_notification!
      run_on_each_subscribed { |user| NotificationMailer.beginning_of_day(user).deliver }
    end

    def send_end_of_day_notification!
      run_on_each_subscribed { |user| NotificationMailer.end_of_day(user).deliver }
    end
    
    def run_on_each_subscribed
      subscribed.each { |user| yield(user) }
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
    scope.order('user_foods.created_at ASC').all
  end
end
