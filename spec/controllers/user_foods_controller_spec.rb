require 'spec_helper'

describe UserFoodsController, type: :controller do
  describe "PUT update" do
    context "when user is not logged in" do
      it "should redirect to sign in" do
        put :update, :params => { :id => "1" }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
    context "when user is logged in" do
      before(:each) do
        login!
        @user_food = FactoryGirl.create(:user_food, :user => @user)
      end

      it "should render template" do
        put :update, :params => { :format => :js, :id => @user_food.id, :user_food => { :amount => 2 } }
        expect(response).to render_template('user_foods/update')
      end

      it "should update user_food for current_user" do
        expect {
          put :update, :params => { :format => :js, :id => @user_food.id, :user_food => { :amount => 2 } }
          @user_food.reload
        }.to change(@user_food, :amount).to(2)
      end

      it "should not update user_food from other users" do
        @another_user_food = FactoryGirl.create(:user_food)
        expect {
          put :update, :params => { :format => :js, :id => @another_user_food.id, :user_food => { :amount => 2 } }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "DELETE destroy" do
    context "when user is not logged in" do
      it "should redirect to sign in" do
        delete :destroy, :params => { :id => "1" }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
    context "when user is logged in" do
      before(:each) do
        login!
        @user_food = FactoryGirl.create(:user_food, :user => @user)
      end

      it "should render template" do
        delete :destroy, :params => { :format => :js, :id => @user_food.id }
        expect(response).to render_template('user_foods/destroy')
      end

      it "should destroy user_food for current_user" do
        expect {
          delete :destroy, :params => { :format => :js, :id => @user_food.id }
        }.to change(@user.user_foods, :count).by(-1)
      end

      it "should not destroy user_food from other users" do
        @another_user_food = FactoryGirl.create(:user_food)
        expect {
          delete :destroy, :params => { :format => :js, :id => @another_user_food.id }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "POST create" do
    context "when user is not logged in" do
      it "should redirect to sign in" do
        post :create
        expect(response).to redirect_to(new_user_session_path)
      end
    end
    context "when user is logged in" do
      before(:each) do
        login!
        @food = FactoryGirl.create(:food)
      end

      def do_post
        post :create, :params => { :format => :js, :user_food => {:food_id => @food.id, :meal => 'breakfast', :date => '2010-10-10'} }
      end

      it "should render template" do
        do_post
        expect(response).to render_template('user_foods/create')
      end

      it "should create user_food for current_user" do
        expect {
          do_post
        }.to change(@user.user_foods, :count).by(1)
      end

      it "should set amount as 1" do
        do_post
        expect(@user.user_foods.last.amount).to eq(1)
      end
    end
  end
end
