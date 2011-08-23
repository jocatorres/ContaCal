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
        login!
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

  describe "PUT update_kcal_limit.js" do
    def do_request(params = {})
      put :update_kcal_limit, {:format => :js}.merge(params)
    end
    context "when user is not logged in" do
      it "should redirect to sign in" do
        do_request
        response.status.should == 401
      end
    end
    context "when user is logged in" do
      before(:each) do
        @user = Factory.create(:user)
        @user.confirm!
        sign_in @user
      end
      it "should update kcal_limit of current user" do
        expect {
          do_request({'kcal_limit' => '100'})
          @user.reload
        }.should change(@user, :kcal_limit).from(nil).to(100)
      end
      it "should be success" do
        do_request
        response.should be_success
      end
      it "should not render layout" do
        do_request
        response.should_not render_template("application")
      end
      it "should render view" do
        do_request
        response.should render_template("dashboard/update_kcal_limit")
      end
    end
  end

end
