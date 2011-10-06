require 'spec_helper'

describe FoodsController do
  describe "GET new" do
    context "when user is not logged in" do
      it "should redirect to sign in" do
        get :new
        response.should redirect_to(new_user_session_path)
      end
    end
    context "when user is logged in" do
      before(:each) do
        login!
      end
      it "should render template" do
        get :new
        response.should render_template('foods/new')
      end
      it "should assign @food" do
        get :new
        assigns(:food).should be_a_new(Food)
      end
    end
  end
end
