require 'spec_helper'

describe UserFoodsController do
  describe "DELETE destroy" do
    context "when user is not logged in" do
      it "should redirect to sign in" do
        delete :destroy, :id => "1"
        response.should redirect_to(new_user_session_path)
      end
    end
    context "when user is logged in" do
      before(:each) do
        login!
        @user_food = Factory.create(:user_food, :user => @user)
      end

      it "should render template" do
        delete :destroy, :format => :js, :id => @user_food.id
        response.should render_template('user_foods/destroy')
      end

      it "should destroy user_food for current_user" do
        lambda do
          delete :destroy, :format => :js, :id => @user_food.id
        end.should change(@user.user_foods, :count).by(-1)
      end

      it "should not destroy user_food from other users" do
        @another_user_food = Factory.create(:user_food)
        lambda do
          delete :destroy, :format => :js, :id => @another_user_food.id
        end.should raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

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

      it "should render template" do
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
