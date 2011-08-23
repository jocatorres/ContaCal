# -*- encoding : utf-8 -*-
require 'spec_helper'

describe User do
  it { should have_many(:user_foods) }
  [:name, :email, :password, :password_confirmation, :remember_me].each do |attr|
    it { should allow_mass_assignment_of(attr) }
  end

  it { should validate_presence_of(:name) }
end
