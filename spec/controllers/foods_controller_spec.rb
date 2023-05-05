# -*- encoding : utf-8 -*-
require 'spec_helper'

describe FoodsController, type: :controller do
  describe "GET new" do
    context "when user is not logged in" do
      it "should redirect to sign in" do
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end
    end
    context "when user is logged in" do
      before(:each) do
        login!
      end
      it "should render template" do
        get :new
        expect(response).to render_template('foods/new')
      end
      it "should assign @food" do
        get :new
        expect(assigns(:food)).to be_a_new(Food)
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
      end
      describe "with valid params" do
        def valid_attributes
          {:name => "Barra de cereais de castanha do pará com chocolate", :weight => '25 Gramas - g', :measure => '1 Unidades', :kcal => '110', :kind => 'a'}
        end
        it "sends email" do
          expect {
            post :create, :params => { :food => valid_attributes }
          }.to change(ActionMailer::Base.deliveries,:size).by(1)
        end
        it "redirects to new food path" do
          post :create, :params => { :food => valid_attributes }
          expect(response).to redirect_to(new_food_path)
        end
        it "set flash message" do
          post :create, :params => { :food => valid_attributes }
          expect(flash[:notice]).to include("Sugestão enviada com sucesso!")
        end
      end
      describe "with invalid params" do
        it "assigns a newly created but unsaved food as @food" do
          Food.any_instance.stub(:valid?).and_return(false)
          post :create, :params => { :food => {} }
          expect(assigns(:food)).to be_a_new(Food)
        end
        it "re-renders the 'new' template" do
          Food.any_instance.stub(:valid?).and_return(false)
          post :create, :params => { :food => {} }
          expect(response).to render_template("new")
        end
      end
    end
  end
end
