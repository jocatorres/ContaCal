require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DashboardController do
  describe "routing" do
    it "recognizes and generates index" do
      get("/").should route_to("dashboard#index")
      root_path.should == '/'
    end

    it "recognizes and generates kcal_limit" do
      put("/kcal_limit").should route_to("dashboard#update_kcal_limit")
      kcal_limit_path.should == '/kcal_limit'
    end

    it "recognizes and generates confirm" do
      get("/autocomplete_food_name").should route_to("dashboard#autocomplete_food_name")
      autocomplete_food_name_path.should == "/autocomplete_food_name"
    end
  end
end
