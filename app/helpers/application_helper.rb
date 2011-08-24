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
    current_user.consumed_kcal(:date => current_date, :kind => kind)/total_kcal*100
  end

  def total_kcal
    @total_kcal ||= current_user.consumed_kcal(:date => current_date)
  end

  def current_date
    @date || @user_food.date
  end
end