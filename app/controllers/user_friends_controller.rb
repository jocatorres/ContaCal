# -*- encoding : utf-8 -*-
class UserFriendsController < ApplicationController
  before_filter :authenticate_user!
  layout 'devise'
  
  def new
    @user_friends = UserFriends.new
  end
  
  def create
    @user_frineds = UserFriends.new(params[:food])
    
    if (!@user_friends.name.blank? && !@user_friends.email.blank?)
      NotificationMailer.new_food(current_user, @user_friends).deliver  
      @user_friends.name.gsub!('+', ' ')
      @user_friends.update_attribute(:kind, "h")      
      @user_friends.update_attribute(:suggester_id, current_user.id)
      @user_friends.save
      redirect_to new_user_friends_path, notice: '<center>Sugestão enviada com sucesso!</center>'
    else
      @user_friends.errors.add(:name, :empty)
      render action: "new"
    end    
  end
end
