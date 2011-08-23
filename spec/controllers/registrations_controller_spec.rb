require 'spec_helper'

describe RegistrationsController do
  
  it "should override after_inactive_sign_up_path_for" do
    controller.send(:after_inactive_sign_up_path_for, nil).should == '/users/confirm'
  end
  
end
