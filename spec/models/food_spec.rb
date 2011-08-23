# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Food do
  it { should have_many(:user_foods) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:weight) }
  it { should validate_presence_of(:measure) }
  it { should validate_presence_of(:kcal) }

  it { should allow_mass_assignment_of(:name) }
  it { should allow_mass_assignment_of(:weight) }
  it { should allow_mass_assignment_of(:measure) }
  it { should allow_mass_assignment_of(:kcal) }
  it { should allow_mass_assignment_of(:kind) }
  
  it "should validate inclusion of :type" do
    Factory.build(:food, :kind => 'a').valid?.should be_true
    Factory.build(:food, :kind => 'b').valid?.should be_true
    Factory.build(:food, :kind => 'c').valid?.should be_true
    Factory.build(:food, :kind => 'd').valid?.should_not be_true
  end
end
