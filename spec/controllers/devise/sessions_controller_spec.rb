# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Devise::SessionsController, type: :controller do
  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "POST create" do
    before(:each) do
      @user = FactoryGirl.create(:user)
    end

    def do_post!
      post :create, :params => { :user => { :email => @user.email, :password => "123456" } }
    end

    context "when user was deleted" do
      before(:each) do
        @time = Time.now
        @user.update_attribute(:deleted_at, @time)
      end
      it "should redirect to root_path" do
        do_post!
        expect(response).to redirect_to("/")
      end
      context "when there is stored return to" do
        it "should undelete user" do
          session["user_return_to"] = "/bla"
          do_post!
          expect {
            @user.reload
          }.to change(@user, :deleted_at).from(@time).to(nil)
        end
      end
      context "when there is NO stored return to" do
        it "should undelete user" do
          do_post!
          expect {
            @user.reload
          }.to change(@user, :deleted_at).from(@time).to(nil)
        end
      end
    end
    context "when user is not deleted" do
      it "should redirect to root_path" do
        do_post!
        expect(response).to redirect_to("/")
      end
    end
  end

  describe "GET destroy" do
    before(:each) do
      login!
    end

    it "should redirect to /" do
      get :destroy
      expect(response).to redirect_to("/")
    end
  end
end