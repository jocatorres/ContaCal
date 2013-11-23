# -*- encoding : utf-8 -*-
class UserFriendsController < ApplicationController
  before_filter :authenticate_user!
  layout 'devise'
  
  def new
    @user_friend = UserFriends.new
  end
  
  def create
    @user_frined = UserFriends.new(params[:user_friend])
    
    if (!@user_friend.name.blank? && !@user_friend.email.blank?)
      NotificationMailer.new_user_friend(current_user, @user_friend).deliver  
      @user_friend.name.gsub!('+', ' ')
      @user_friend.update_attribute(:kind, "h")      
      @user_friend.update_attribute(:suggester_id, current_user.id)
      @user_friend.save
      redirect_to new_user_friend_path, notice: '<center>Sugestão enviada com sucesso!</center>'
    else
      @user_friend.errors.add(:name, :empty)
      render action: "new"
    end    
  end
end
