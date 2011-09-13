# -*- encoding : utf-8 -*-
class DashboardController < ApplicationController
  before_filter :authenticate_user!
  
  def autocomplete_food_name
    extra_data = [:id, :name]

    pieces = []
    terms = []
    params[:term].split(" ").each do |term|
      pieces << "#{translate_to_remove_accents("name")} like #{translate_to_remove_accents("?")}"
      terms << "%#{term.downcase}%"
    end
    where_clause = pieces.join(" and ")
    @foods = Food.where(where_clause, *terms).limit(100).all
    @foods << Food.new(:name => "#{params[:term]} não encontrado.") if @foods.empty?
    render :json => json_for_autocomplete(@foods, :name, extra_data)
  end

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
    case params[:range]
    when 'month'
      @days = 30
    else
      @days = 7
    end
    (@days.days.ago.to_date..Date.today).each do |date|
      bar = [l(date, :format => :chart),consumed_kcal(date, "a"), consumed_kcal(date, "b"), consumed_kcal(date, "c")]
      bar << current_user.kcal_limit  unless current_user.kcal_limit.nil?
      data << bar
    end
    bar = ["",0,0,0]
    bar << current_user.kcal_limit  unless current_user.kcal_limit.nil?
    data << bar

    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('string', 'Data' )
    data_table.new_column('number', 'Caloria Verde')
    data_table.new_column('number', 'Caloria Amarela')
    data_table.new_column('number', 'Caloria Vermelha')
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

  def translate_to_remove_accents(value)
    %{translate(lower(#{value}),'áâãäåāăąèééêëēĕėęěìíîïìĩīĭóôõöōŏőùúûüũūŭůçćčĉċ','aaaaaaaaeeeeeeeeeeiiiiiiiiooooooouuuuuuuccccc')}
  end
end
