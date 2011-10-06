require 'spec_helper'

describe FoodsController do
  describe "routing" do
    it "recognizes and generates new" do
      get("/foods/new").should route_to("foods#new")
      new_food_path.should == '/foods/new'
    end
    it "recognizes and generates create" do
      post("/foods").should route_to("foods#create")
      foods_path.should == '/foods'
    end
  end
end
