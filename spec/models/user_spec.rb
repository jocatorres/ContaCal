# -*- encoding : utf-8 -*-
require 'spec_helper'

describe User do
  it { should have_many(:user_foods) }
  [:name, :email, :password, :password_confirmation, :remember_me, :cpf, :address_street_and_number, :address_city, :address_state, :address_zipcode, :kcal_limit, :subscribed].each do |attr|
    it { should allow_mass_assignment_of(attr) }
  end

  it { should validate_presence_of(:name) }

  describe "subscribed scope" do
    it "should not return user" do
      @user = Factory.create(:user, :subscribed => false)
      User.subscribed.should_not include(@user)
    end

    it "should return user" do
      @user = Factory.create(:user, :subscribed => true)
      User.subscribed.should include(@user)
    end
  end

  describe "consumed_kcal" do
    before(:each) do
      @user = Factory.create(:user)
      @food1 = Factory.create(:food, :kcal => 300)
      @food2 = Factory.create(:food, :kcal => 100, :kind => 'b')
    end
    context "requesting for a day" do
      context "there is no food" do
        it "should return 0" do
          @user.consumed_kcal.should == 0
        end
      end
      context "there is one food eaten today and twice" do
        before(:each) do
          Factory.create(:user_food, :user => @user, :food => @food1, :date => Date.today, :meal => 'breakfast', :amount => 2)
          Factory.create(:user_food, :user => @user, :food => @food2, :date => Date.today, :meal => 'breakfast', :amount => 1)
        end
        context "no meal requested" do
          context "no kind requested" do
            it "should return the kcal of food" do
              @user.consumed_kcal.should == 700
            end
          end
          context "food eaten on kind requested" do
            it "should return the kcal of food" do
              @user.consumed_kcal(:kind => 'a').should == 600
            end            
          end
          context "food eaten on another kind not requested" do
            it "should return the kcal of food" do
              @user.consumed_kcal(:kind => 'b').should == 100
            end
            it "should return the kcal of food" do
              @user.consumed_kcal(:kind => 'c').should == 0
            end
          end
        end
        context "food eaten on meal requested" do
          it "should return the kcal of food" do
            @user.consumed_kcal(:meal => 'breakfast').should == 700
          end
        end
        context "food eaten on another meal not requested" do
          it "should return the kcal of food" do
            @user.consumed_kcal(:meal => 'lunch').should == 0
          end
        end
      end
      context "there is one food eaten another day" do
        before(:each) do
          Factory.create(:user_food, :user => @user, :food => @food1, :date => Date.new(2011,8,20), :meal => 'breakfast', :amount => 2)
        end
        context "no meal requested" do
          it "should return the kcal of food" do
            Timecop.freeze(2011,8,23) do
              @user.consumed_kcal.should == 0
            end
          end
        end
        context "food eaten on meal requested" do
          it "should return the kcal of food" do
            Timecop.freeze(2011,8,23) do
              @user.consumed_kcal(:meal => 'breakfast').should == 0
            end
          end
        end
        context "food eaten on another meal not requested" do
          it "should return the kcal of food" do
            Timecop.freeze(2011,8,23) do
              @user.consumed_kcal(:meal => 'lunch').should == 0
            end
          end
        end
      end
      context "there is one food eaten on requested day" do
        before(:each) do
          Factory.create(:user_food, :user => @user, :food => @food1, :date => Date.new(2011,8,20), :meal => 'breakfast', :amount => 2)
        end
        context "no meal requested" do
          it "should return the kcal of food" do
            @user.consumed_kcal(:date => Date.new(2011,8,20)).should == 600
          end
        end
        context "food eaten on meal requested" do
          it "should return the kcal of food" do
            @user.consumed_kcal(:date => Date.new(2011,8,20), :meal => 'breakfast').should == 600
          end
        end
        context "food eaten on another meal not requested" do
          it "should return the kcal of food" do
            @user.consumed_kcal(:date => Date.new(2011,8,20), :meal => 'lunch').should == 0
          end
        end
      end
      context "there is no food eaten on requested day" do
        before(:each) do
          Factory.create(:user_food, :user => @user, :food => @food1, :date => Date.new(2011,8,20), :meal => 'breakfast', :amount => 2)
        end
        context "no meal requested" do
          it "should return the kcal of food" do
            @user.consumed_kcal(:date => Date.new(2011,8,22)).should == 0
          end
        end
        context "food eaten on meal requested" do
          it "should return the kcal of food" do
            @user.consumed_kcal(:date => Date.new(2011,8,22), :meal => 'breakfast').should == 0
          end
        end
        context "food eaten on another meal not requested" do
          it "should return the kcal of food" do
            @user.consumed_kcal(:date => Date.new(2011,8,22), :meal => 'lunch').should == 0
          end
        end
      end
    end
  end
  describe "consumed_foods" do
    before(:each) do
      @user = Factory.create(:user)
      @food1 = Factory.create(:food, :kcal => 100)
      @food2 = Factory.create(:food, :kcal => 200)
    end
    context "requesting for a day" do
      context "there is no food" do
        it "should return 0" do
          @user.consumed_foods.should == []
        end
      end
      context "there is one food eaten today and twice" do
        before(:each) do
          @user_food1 = Factory.create(:user_food, :user => @user, :food => @food1, :date => Date.today, :meal => 'breakfast', :amount => 2)
          @user_food2 = Factory.create(:user_food, :user => @user, :food => @food2, :date => Date.today, :meal => 'breakfast', :amount => 2)
        end
        context "no meal requested" do
          it "should return the kcal of food" do
            @user.consumed_foods.should == [@user_food1, @user_food2]
          end
        end
        context "food eaten on meal requested" do
          it "should return the kcal of food" do
            @user.consumed_foods(:meal => 'breakfast').should == [@user_food1, @user_food2]
          end
        end
        context "food eaten on another meal not requested" do
          it "should return the kcal of food" do
            @user.consumed_foods(:meal => 'lunch').should == []
          end
        end
      end
      context "there is one food eaten another day" do
        before(:each) do
          @user_food1 = Factory.create(:user_food, :user => @user, :food => @food1, :date => Date.new(2011,8,20), :meal => 'breakfast', :amount => 2)
          @user_food2 = Factory.create(:user_food, :user => @user, :food => @food2, :date => Date.new(2011,8,20), :meal => 'breakfast', :amount => 2)
        end
        context "no meal requested" do
          it "should return the kcal of food" do
            Timecop.freeze(2011,8,23) do
              @user.consumed_foods.should == []
            end
          end
        end
        context "food eaten on meal requested" do
          it "should return the kcal of food" do
            Timecop.freeze(2011,8,23) do
              @user.consumed_foods(:meal => 'breakfast').should == []
            end
          end
        end
        context "food eaten on another meal not requested" do
          it "should return the kcal of food" do
            Timecop.freeze(2011,8,23) do
              @user.consumed_foods(:meal => 'lunch').should == []
            end
          end
        end
      end
      context "there is one food eaten on requested day" do
        before(:each) do
          @user_food1 = Factory.create(:user_food, :user => @user, :food => @food1, :date => Date.new(2011,8,20), :meal => 'breakfast', :amount => 2)
          @user_food2 = Factory.create(:user_food, :user => @user, :food => @food2, :date => Date.new(2011,8,20), :meal => 'breakfast', :amount => 2)
        end
        context "no meal requested" do
          it "should return the kcal of food" do
            @user.consumed_foods(:date => Date.new(2011,8,20)).should == [@user_food1, @user_food2]
          end
        end
        context "food eaten on meal requested" do
          it "should return the kcal of food" do
            @user.consumed_foods(:date => Date.new(2011,8,20), :meal => 'breakfast').should == [@user_food1, @user_food2]
          end
        end
        context "food eaten on another meal not requested" do
          it "should return the kcal of food" do
            @user.consumed_foods(:date => Date.new(2011,8,20), :meal => 'lunch').should == []
          end
        end
      end
      context "there is no food eaten on requested day" do
        before(:each) do
          @user_food1 = Factory.create(:user_food, :user => @user, :food => @food1, :date => Date.new(2011,8,20), :meal => 'breakfast', :amount => 2)
          @user_food2 = Factory.create(:user_food, :user => @user, :food => @food2, :date => Date.new(2011,8,20), :meal => 'breakfast', :amount => 2)
        end
        context "no meal requested" do
          it "should return the kcal of food" do
            @user.consumed_foods(:date => Date.new(2011,8,22)).should == []
          end
        end
        context "food eaten on meal requested" do
          it "should return the kcal of food" do
            @user.consumed_foods(:date => Date.new(2011,8,22), :meal => 'breakfast').should == []
          end
        end
        context "food eaten on another meal not requested" do
          it "should return the kcal of food" do
            @user.consumed_foods(:date => Date.new(2011,8,22), :meal => 'lunch').should == []
          end
        end
      end
    end
  end
end
