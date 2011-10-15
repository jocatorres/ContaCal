# -*- encoding : utf-8 -*-
module DashboardHelper
  def display_daily_total(date)
    spent    = user.spent_kcal(:date => date)
    consumed = user.consumed_kcal(:date => date)
    net = consumed - spent

    if spent > 0
      "#{number_with_precision(consumed, :precision => 0)} ingeridas - #{number_with_precision(spent, :precision => 0)} gastas = #{number_with_precision(net, :precision => 0)}"
    else
      number_with_precision(consumed, :precision => 0)
    end
  end
end
