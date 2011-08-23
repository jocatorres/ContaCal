require 'spec_helper'

describe FoodsController do
  describe "GET index" do
    context "when user is not logged in" do
      it "should redirect to sign in" do
        get :index
        response.should redirect_to(new_user_session_path)
      end
    end
    context "when user is logged in" do
      before(:each) do
        login!
      end

      it "should return all food" do
        Food.should_receive(:all).and_return(['food'])
        get :index
        assigns(:foods).should == ['food']
      end

      it "should be success" do
        get :index
        response.should be_success
      end
    end
  end
end
