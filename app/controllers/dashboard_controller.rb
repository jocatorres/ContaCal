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
  end

  def report
    data = []
    bar = ["",0,0,0]
    bar << current_user.kcal_limit  unless current_user.kcal_limit.nil?
    data << bar
    (6.days.ago.to_date..Date.today).each do |date|
      bar = [l(date, :format => :chart),consumed_kcal(date, "a"), consumed_kcal(date, "b"), consumed_kcal(date, "c")]
      bar << current_user.kcal_limit  unless current_user.kcal_limit.nil?
      data << bar
    end
    bar = ["",0,0,0]
    bar << current_user.kcal_limit  unless current_user.kcal_limit.nil?
    data << bar

    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('string', 'Data' )
    data_table.new_column('number', 'Verde')
    data_table.new_column('number', 'Amarelo')
    data_table.new_column('number', 'Vermelho')
    data_table.new_column('number', 'Limite diário de calorias') unless current_user.kcal_limit.nil?
    data_table.add_rows(data)
    chart_options = {
      :title => 'Controle de Calorias',
      :vAxis => {:title => 'Calorias'},
      :isStacked => true,
      :width => 900, 
      :height => 400,
      :legend => 'none',
      :colors => ['#6ba16c','#f7f143','#f75443'],
    }
    chart_options[:series] = {3 => {:type => 'line', :color => 'black', :lineWidth => 3, :visibleInLegend => false}} unless current_user.kcal_limit.nil?
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
