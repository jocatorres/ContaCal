# -*- encoding : utf-8 -*-
module ApplicationHelper
  def percent_kcal_kind_a
    percent_kcal_kind('a')
  end

  def percent_kcal_kind_b
    percent_kcal_kind('b')
  end

  def percent_kcal_kind_c
    percent_kcal_kind('c')
  end

  private
  def percent_kcal_kind(kind)
    user.consumed_kcal(:date => current_date, :kind => kind)/total_kcal*100
  end
  
  def total_kcal
    @total_kcal ||= user.consumed_kcal(:date => current_date)
  end

  # this methos was created to make this helper work with emails
  def user
    current_user rescue @user
  end

  def current_date
    @date || @user_food.date
  end
  
  def has_flash_messages?
    flashes = [:alert, :notice, :warning, :message, :failure]
    flash and flashes.find { |key| flash.has_key?(key) }
  end

  def render_flash_messages
    return unless has_flash_messages?
    buffer = "<div id=\"flash\">"
    #[:alert, :notice, :warning, :message, :failure].each do |name|
    flash.each do |name, text|
      html_class = (:notice == name or :message == name) ? "flash_notice" : "flash_alert"
      buffer << "<div id=\"messages\"><dl class=\"#{html_class}\"><dt>#{flash[name]}</dt></dl></div>"
    end
    buffer << "</div>"
    buffer.html_safe
  end
end