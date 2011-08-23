require 'spec_helper'

describe UserFoodsController do
  describe "routing" do
    it "recognizes and generates create" do
      post("/user_foods").should route_to("user_foods#create")
      user_foods_path.should == '/user_foods'
    end
  end
end
