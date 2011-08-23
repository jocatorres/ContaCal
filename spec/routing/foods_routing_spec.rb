require 'spec_helper'

describe FoodsController do
  describe "routing" do
    it "recognizes and generates confirm" do
      get("/foods").should route_to("foods#index")
      foods_path.should == '/foods'
    end
  end
end
