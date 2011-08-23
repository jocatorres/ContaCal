# -*- encoding : utf-8 -*-
require 'spec_helper'

describe User do
  it { should have_many(:user_foods) }
  [:name, :email, :password, :password_confirmation, :remember_me, :cpf, :address_street_and_number, :address_city, :address_state, :address_zipcode].each do |attr|
    it { should allow_mass_assignment_of(attr) }
  end

  it { should validate_presence_of(:name) }
end
