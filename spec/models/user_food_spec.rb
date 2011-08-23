require 'spec_helper'

describe UserFood do
  it { should belong_to(:user) }
  it { should belong_to(:food) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:food) }
  it { should validate_presence_of(:date) }
  it { should validate_numericality_of(:amount) }
  it "should validate inclusion of :meal" do
    ['breakfast', 'brunch', 'lunch', 'tea', 'dinner', 'supper'].each do |meal|
      Factory.build(:user_food, :meal => meal).valid?.should be_true
    end
    Factory.build(:user_food, :meal => 'notvalid').valid?.should_not be_true
  end
  
  describe "on creation" do
    before(:each) do
      @food = Factory.create(:food, :kcal => 120)
    end
    context "amount = 1" do
      it "should set kcal with food.kcal*amount" do
        @user_food = Factory.create(:user_food, :food => @food, :amount => 1)
        @user_food.kcal.should == 120
      end
    end
    context "amount > 1" do
      it "should set kcal with food.kcal*amount" do
        @user_food = Factory.create(:user_food, :food => @food, :amount => 3)
        @user_food.kcal.should == 360
      end
    end
  end
  
end
