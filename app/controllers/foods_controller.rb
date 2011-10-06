class FoodsController < ApplicationController
  before_filter :authenticate_user!
  layout 'devise'
  
  def new
    @food = Food.new
  end
end
