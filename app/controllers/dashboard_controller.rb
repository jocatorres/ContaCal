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
    data = [["", 0, 0, 0, 80], ["28/10/2011", 70, 20, 10, 80], ["29/10/2011", 20, 70, 10, 80], ["30/10/2011", 20, 40, 40, 80], ["30/10/2011", 20, 40, 40, 80], ["30/10/2011", 20, 40, 40, 80], ["30/10/2011", 20, 40, 40, 80], ["30/10/2011", 20, 40, 40, 80], ["", 0, 0, 0, 80]]
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
end
