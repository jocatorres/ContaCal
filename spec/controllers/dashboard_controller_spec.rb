# -*- encoding : utf-8 -*-
require 'spec_helper'

describe DashboardController, type: :controller do

  describe "GET autocomplete_food_name" do
    context "when user is not logged in" do
      it "should redirect to sign in" do
        get :authenticate
        expect(response).to redirect_to(new_user_session_path)
      end
    end
    context "when user is logged in" do
      before(:each) do
        login!
      end
      it "should return ok" do
        get :authenticate
        expect(response).to be_ok
      end
    end
  end

  describe "GET autocomplete_food_name" do
    context "when user is not logged in" do
      it "should redirect to sign in" do
        get :autocomplete_food_name, :params => { :term => 'tomate' }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
    context "when user is logged in" do
      before(:each) do
        login!
      end
      
      it "should assin foods for pão" do
        @pao = FactoryGirl.create(:food, :name => 'Pão')
        @pudim_pao = FactoryGirl.create(:food, :name => 'Pudim de Pão')
        @pao_integral = FactoryGirl.create(:food, :name => 'Pão Integral')
        @pao_forma_integral = FactoryGirl.create(:food, :name => 'Pão de Forma Integral')
        get :autocomplete_food_name, :params => { :term => 'pão' }
        expect(assigns(:foods)).to include(@pao)
        expect(assigns(:foods)).to include(@pudim_pao)
        expect(assigns(:foods)).to include(@pao_integral)
        expect(assigns(:foods)).to include(@pao_forma_integral)
      end

      it "should assin foods for pao" do
        @pao = FactoryGirl.create(:food, :name => 'Pão')
        @pudim_pao = FactoryGirl.create(:food, :name => 'Pudim de Pão')
        @pao_integral = FactoryGirl.create(:food, :name => 'Pão Integral')
        @pao_forma_integral = FactoryGirl.create(:food, :name => 'Pão de Forma Integral')
        get :autocomplete_food_name, :params => { :term => 'pao' }
        expect(assigns(:foods)).to include(@pao)
        expect(assigns(:foods)).to include(@pudim_pao)
        expect(assigns(:foods)).to include(@pao_integral)
        expect(assigns(:foods)).to include(@pao_forma_integral)
      end

      it "should assin foods for pão integral" do
        @pao = FactoryGirl.create(:food, :name => 'Pão')
        @pudim_pao = FactoryGirl.create(:food, :name => 'Pudim de Pão')
        @pao_integral = FactoryGirl.create(:food, :name => 'Pão Integral')
        @pao_forma_integral = FactoryGirl.create(:food, :name => 'Pão de Forma Integral')
        get :autocomplete_food_name, :params => { :term => 'pão integral' }
        expect(assigns(:foods)).to_not include(@pao)
        expect(assigns(:foods)).to_not include(@pudim_pao)
        expect(assigns(:foods)).to include(@pao_integral)
        expect(assigns(:foods)).to include(@pao_forma_integral)
      end


      it "should order correctly" do
        @pudim_pao = FactoryGirl.create(:food, :name => 'Pudim de Pão')
        @doce_pao = FactoryGirl.create(:food, :name => 'Doce de Pão')
        @pao_integral = FactoryGirl.create(:food, :name => 'Pão Integral')
        @pao_forma_integral = FactoryGirl.create(:food, :name => 'Pão de Forma Integral')
        @pao = FactoryGirl.create(:food, :name => 'Pão')
        
        get :autocomplete_food_name, :params => { :term => 'pao' }
        expect(assigns(:foods)).to include(@pao, @pao_forma_integral, @pao_integral, @doce_pao, @pudim_pao)
      end

      it "should be success" do
        get :autocomplete_food_name, :params => { :term => 'tomate' }
        expect(response).to be_success
      end
    end
  end

  describe "GET report" do
    context "when user is not logged in" do
      it "should redirect to sign in" do
        get :report
        expect(response).to redirect_to(new_user_session_path)
      end
    end
    context "when user is logged in" do
      before(:each) do
        login!
      end

      it "should be success" do
        get :report
        expect(response).to be_success
      end
      it "should render layout" do
        get :report
        expect(response).to render_template("application")
      end
      it "should render view" do
        get :report
        expect(response).to render_template("dashboard/report")
      end
      it "should assign graph" do
        get :report
        expect(assigns(:graph)).to_not be_nil
      end
    end
  end

  describe "GET index" do
    context "when user is not logged in" do
      it "should redirect to sign in" do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end
    context "when user is logged in" do
      before(:each) do
        login!
      end
      context "no date passed" do
        it "should assign today as date" do
          get :index
          expect(assigns(:date)).to eq(Date.today)
        end
        it "should assign yesterday as previous_day" do
          get :index
          expect(assigns(:previous_day)).to eq(Date.today-1.day)
        end
        it "should assign tomorrow as next_day" do
          get :index
          expect(assigns(:next_day)).to eq(Date.today+1.day)
        end
      end
      context "when date is passed" do
        it "should assign requested date as date" do
          get :index, :params => { :year => '2011', :month => '07', :day => '24' }
          expect(assigns(:date)).to eq(Date.new(2011,7,24))
        end
        it "should assign the day before requested date as previous_day" do
          get :index, :params => { :year => '2011', :month => '07', :day => '24' }
          expect(assigns(:previous_day)).to eq(Date.new(2011,7,23))
        end
        it "should assign the day after requested date as next_day" do
          get :index, :params => { :year => '2011', :month => '07', :day => '24' }
          expect(assigns(:next_day)).to eq(Date.new(2011,7,25))
        end
      end
      it "should be success" do
        get :index
        expect(response).to be_success
      end
      it "should render layout" do
        get :index
        expect(response).to render_template("application")
      end
      it "should render view" do
        get :index
        expect(response).to render_template("dashboard/index")
      end
    end
  end

  describe "PUT update_kcal_limit.js" do
    def do_request(params = {})
      put :update_kcal_limit, :params => {:format => :js}.merge(params)
    end
    context "when user is not logged in" do
      it "should redirect to sign in" do
        do_request
        expect(response.status).to eq(401)
      end
    end
    context "when user is logged in" do
      before(:each) do
        @user = FactoryGirl.create(:user)
        sign_in @user
      end
      it "should update kcal_limit of current user" do
        expect {
          do_request({'kcal_limit' => '980'})
          @user.reload
        }.to change(@user, :kcal_limit).from(1000).to(980)
      end
      it "should be success" do
        do_request
        expect(response).to be_success
      end
      it "should not render layout" do
        do_request
        expect(response).to_not render_template("application")
      end
      it "should render view" do
        do_request
        expect(response).to render_template("dashboard/update_kcal_limit")
      end
    end
  end

end
