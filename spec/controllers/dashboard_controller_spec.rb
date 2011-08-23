require 'spec_helper'

describe DashboardController do

  describe "GET index" do
    context "when user is not logged in" do
      it "should redirect to sign in" do
        get :index
        response.should redirect_to(new_user_session_path)
      end
    end
    context "when user is logged in" do
      before(:each) do
        @user = Factory.create(:user)
        @user.confirm!
        sign_in @user
      end
      it "should be success" do
        get :index
        response.should be_success
      end

      it "should render layout" do
        get :index
        response.should render_template("application")
      end

      it "should render view" do
        get :index
        response.should render_template("dashboard/index")
      end
    end
  end

end
