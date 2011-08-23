class FoodsController < ApplicationController
  before_filter :authenticate_user!
  respond_to :json

  def index
    @foods = Food.all
    render :json => @foods
  end
end
