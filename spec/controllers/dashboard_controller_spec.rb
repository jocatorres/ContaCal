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
      context "no date passed" do
        it "should assign today as date" do
          get :index
          assigns(:date).should == Date.today
        end
        it "should assign yesterday as previous_day" do
          get :index
          assigns(:previous_day).should == Date.today-1.day
        end
        it "should assign tomorrow as next_day" do
          get :index
          assigns(:next_day).should == Date.today+1.day
        end
      end
      context "when date is passed" do
        it "should assign requested date as date" do
          get :index, :year => '2011', :month => '07', :day => '24'
          assigns(:date).should == Date.new(2011,7,24)
        end
        it "should assign the day before requested date as previous_day" do
          get :index, :year => '2011', :month => '07', :day => '24'
          assigns(:previous_day).should == Date.new(2011,7,23)
        end
        it "should assign the day after requested date as next_day" do
          get :index, :year => '2011', :month => '07', :day => '24'
          assigns(:next_day).should == Date.new(2011,7,25)
        end
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
