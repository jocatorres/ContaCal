require 'spec_helper'

describe UserFoodsController do
  describe "POST create" do
    context "when user is not logged in" do
      it "should redirect to sign in" do
        post :create
        response.should redirect_to(new_user_session_path)
      end
    end
    context "when user is logged in" do
      before(:each) do
        login!
        @food = Factory.create(:food)
      end

      def do_post
        post :create, :format => :js, :user_food => {:food_id => @food.id, :meal => 'breakfast', :date => '2010-10-10'}
      end

      it "should redirect to root_url" do
        do_post
        response.should render_template('user_foods/create')
      end

      it "should create user_food for current_user" do
        lambda do
          do_post
        end.should change(@user.user_foods, :count).by(1)
      end

      it "should set amount as 1" do
        do_post
        @user.user_foods.last.amount.should == 1
      end
    end
  end
end
