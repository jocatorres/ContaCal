# -*- encoding : utf-8 -*-
class DashboardController < ApplicationController
  before_filter :authenticate_user!
  autocomplete :food, :name, :full => true
  
  def index
    begin
      @date = Date.parse("#{params[:year]}-#{params[:month]}-#{params[:day]}")
    rescue
      @date = Date.today
    end
    @next_day = @date+1.day
    @previous_day = @date-1.day
    
    @total_kcal = current_user.consumed_kcal(:date => @date)
    @percent_kcal_kind_a = current_user.consumed_kcal(:date => @date, :kind => 'a')/@total_kcal*100
    @percent_kcal_kind_b = current_user.consumed_kcal(:date => @date, :kind => 'b')/@total_kcal*100
    @percent_kcal_kind_c = current_user.consumed_kcal(:date => @date, :kind => 'c')/@total_kcal*100
  end

  def report
    data = [["",0,0,0, current_user.kcal_limit]]
    (6.days.ago.to_date..Date.today).each do |date|
      data << [date.to_s(:db),consumed_kcal(date, "a"), consumed_kcal(date, "b"), consumed_kcal(date, "c"), current_user.kcal_limit]
    end
    data << ["",0,0,0, current_user.kcal_limit]

    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('string', 'Data' )
    data_table.new_column('number', 'Vermelho')
    data_table.new_column('number', 'Amarelo')
    data_table.new_column('number', 'Verde')
    data_table.new_column('number', 'Limite diário')
    data_table.add_rows(data)
    chart_options = {
      :isStacked => 'true',
      :width => 800, 
      :height => 400, 
      :colors => ['#DB281A','#F1BA31','#72F6A0'], 
      :series => {3 => {:type => 'line', :color => 'black'}}
    }
    @graph = GoogleVisualr::Interactive::ColumnChart.new(data_table, chart_options)
  end

  def update_kcal_limit
    current_user.update_attributes({:kcal_limit => params[:kcal_limit]})
  end
  
  private
  def consumed_kcal(date, kind)
    current_user.consumed_kcal(:date => date, :kind => kind)
  end
end
