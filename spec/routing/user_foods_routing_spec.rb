require 'spec_helper'

describe UserFoodsController do
  describe "routing" do
    it "recognizes and generates update" do
      put("/user_foods/1").should route_to("user_foods#update", :id => "1")
      user_food_path(1).should == '/user_foods/1'
    end
    it "recognizes and generates create" do
      post("/user_foods").should route_to("user_foods#create")
      user_foods_path.should == '/user_foods'
    end
    it "recognizes and generates destroy" do
      delete("/user_foods/1").should route_to("user_foods#destroy", :id => "1")
      user_food_path(1).should == '/user_foods/1'
    end
  end
end
