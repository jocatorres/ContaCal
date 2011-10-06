# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Devise::SessionsController do
  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "POST create" do
    before(:each) do
      @user = Factory.create(:user)
      @user.confirm!
    end

    def do_post!
      post :create, :user => { :email => @user.email, :password => "123456" }
    end

    context "when user was deleted" do
      before(:each) do
        @time = Time.now
        @user.update_attribute(:deleted_at, @time)
      end
      it "should redirect to root_path" do
        do_post!
        response.should redirect_to("/")
      end
      it "should undelete user" do
        do_post!
        expect do
          @user.reload
        end.should change(@user, :deleted_at).from(@time).to(nil)
      end
    end
    context "when user is not deleted" do
      it "should redirect to root_path" do
        do_post!
        response.should redirect_to("/")
      end
    end
  end

  describe "GET destroy" do
    before(:each) do
      login!
    end

    it "should redirect to /" do
      get :destroy
      response.should redirect_to("/")
    end
  end
end