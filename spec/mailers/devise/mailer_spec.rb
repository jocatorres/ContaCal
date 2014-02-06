# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Devise::Mailer do
  
  before(:each) do
    @user =  Factory.create(:user, :name => 'Nome do Usuario', :email => 'emaildousuario@example.com')
    @user.reset_password_token = "[reset_password_token]"
  end
  
  describe "reset_password_instructions" do
    it "should render successfully" do
      lambda { Devise::Mailer.reset_password_instructions(@user) }.should_not raise_error
    end
    describe "rendered without error" do
      before(:each) do
        @mailer = Devise::Mailer.reset_password_instructions(@user)
      end
      it "should set correct subject" do
        @mailer.subject.should == "[ContaCal] Instruções de reinicialização de senha"
      end
      it "should set correct header To" do
        # Ele não coloca as aspas por que não receonhece nenhum caracter UTF-8 (acento)
        @mailer.header['To'].to_s.should == "emaildousuario@example.com"
      end
      it "should not have more than one to address" do
        @mailer.to.size.should == 1
      end
      it "should consider CC on recipients address" do
        @mailer.cc.should be_nil
      end
      it "should consider CC on recipients address" do
        @mailer.bcc.should be_nil
      end
      it "should set correct header From" do
        # Ele coloca as aspas por que reconhece que existe um caracter UTF-8 (acento)
        @mailer.header['From'].to_s.should == "Info ContaCal <info@contacal.com.br>"
      end
      it "should not have more than one from address" do
        @mailer.from.size.should == 1
      end
      it "should be multipart" do
        @mailer.multipart?.should be_false
      end
      it "should set correct charset" do
        @mailer.charset.should == "UTF-8"
      end
      it "should set correct body for text html" do
        body = @mailer.body.to_s
        filename = Rails.root.join('spec','fixtures','mailers','reset_password_instructions.html')
        File.open(filename, 'w') {|f| f.write(body) } unless File.exists?(filename)
        body.should == File.read(filename)
      end
      it "should set correct content type" do
        @mailer.content_type.should == "text/html; charset=UTF-8"
      end
      it "should deliver successfully" do
        lambda { Devise::Mailer.reset_password_instructions(@user).deliver }.should_not raise_error
      end
      describe "and delivered" do
        it "should be added to the delivery queue" do
          lambda { Devise::Mailer.reset_password_instructions(@user).deliver }.should change(ActionMailer::Base.deliveries,:size).by(1)
        end
      end
    end
  end
end