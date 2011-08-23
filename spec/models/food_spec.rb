# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Food do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:weight) }
  it { should validate_presence_of(:measure) }
  it { should validate_presence_of(:kcal) }

  it { should allow_mass_assignment_of(:name) }
  it { should allow_mass_assignment_of(:weight) }
  it { should allow_mass_assignment_of(:measure) }
  it { should allow_mass_assignment_of(:kcal) }
  it { should allow_mass_assignment_of(:type) }
  
  it "should validate inclusion of :type" do
    Factory.build(:food, :type => 'a').valid?.should be_true
    Factory.build(:food, :type => 'b').valid?.should be_true
    Factory.build(:food, :type => 'c').valid?.should be_true
    Factory.build(:food, :type => 'd').valid?.should_not be_true
  end
end
