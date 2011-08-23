require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ConfirmationController do
  describe "routing" do
    it "recognizes and generates confirm" do
      get("/users/confirm").should route_to("confirmation#index")
      user_confirm_path.should == '/users/confirm'
    end
  end
end
