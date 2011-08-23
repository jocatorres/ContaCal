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
end
