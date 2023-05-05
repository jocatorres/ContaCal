# -*- encoding : utf-8 -*-
require 'spec_helper'

describe RegistrationsController, type: :controller do
  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  it "should override after_inactive_sign_up_path_for" do
    expect(controller.send(:after_inactive_sign_up_path_for, nil)).to eq('/users/confirm')
  end

  describe "DELETE destroy" do
    before(:each) do
      login!
    end

    it "should redirect to survey url" do
      delete :destroy
      expect(response).to redirect_to("https://docs.google.com/a/jig.com.br/spreadsheet/viewform?formkey=dFBMUV9fd2x4aVZJOFJ2V3JVTmxlQmc6MQ")
    end
  end  

end