require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DashboardController do
  describe "routing" do
    it "recognizes and generates confirm" do
      get("/").should route_to("dashboard#index")
      root_path.should == '/'
    end
  end
end
