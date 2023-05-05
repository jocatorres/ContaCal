require 'spec_helper'

describe UserFood, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:food) }
  it { is_expected.to validate_presence_of(:user) }
  it { is_expected.to validate_presence_of(:food) }
  it { is_expected.to validate_presence_of(:date) }
  it { is_expected.to validate_numericality_of(:amount) }
  it "should validate inclusion of :meal" do
    ['breakfast', 'brunch', 'lunch', 'tea', 'dinner', 'supper'].each do |meal|
      expect(FactoryGirl.build(:user_food, :meal => meal).valid?).to be_truthy
    end
    expect(Factory.build(:user_food, :meal => 'notvalid').valid?).to be_falsey
  end

  describe "on creation" do
    before(:each) do
      @food = FactoryGirl.create(:food, :kcal => 120)
    end
    context "amount = 1" do
      it "should set kcal with food.kcal*amount" do
        @user_food = FactoryGirl.create(:user_food, :food => @food, :amount => 1)
        expect(@user_food.kcal).to eq(120)
      end
    end
    context "amount > 1" do
      it "should set kcal with food.kcal*amount" do
        @user_food = FactoryGirl.create(:user_food, :food => @food, :amount => 3)
        expect(@user_food.kcal).to eq(360)
      end
    end
  end
end
