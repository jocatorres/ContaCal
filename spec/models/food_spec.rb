# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Food, type: :model do
  it { is_expected.to have_many(:user_foods) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:weight) }
  it { is_expected.to validate_presence_of(:measure) }
  it { is_expected.to validate_presence_of(:kcal) }
  
  it "should validate inclusion of :type" do
    expect(FactoryGirl.build(:food, :kind => 'a').valid?).to be_truthy
    expect(FactoryGirl.build(:food, :kind => 'b').valid?).to be_truthy
    expect(FactoryGirl.build(:food, :kind => 'c').valid?).to be_truthy
    expect(FactoryGirl.build(:food, :kind => 'd').valid?).to be_truthy
    expect(FactoryGirl.build(:food, :kind => 'e').valid?).to be_falsey
  end
end
