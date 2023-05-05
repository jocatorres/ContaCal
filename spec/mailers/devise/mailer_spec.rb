# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Devise::Mailer, type: :mailer do
  
  before(:each) do
    @user =  FactoryGirl.create(:user, :name => 'Nome do Usuario', :email => 'emaildousuario@example.com')
    @user.reset_password_token = "[reset_password_token]"
  end
  
  describe "reset_password_instructions" do
    it "should render successfully" do
      expect { Devise::Mailer.reset_password_instructions(@user) }.to_not raise_error
    end
    describe "rendered without error" do
      before(:each) do
        @mailer = Devise::Mailer.reset_password_instructions(@user)
      end
      it "should set correct subject" do
        expect(@mailer.subject).to eq("[ContaCal] Instruções de reinicialização de senha")
      end
      it "should set correct header To" do
        # Ele não coloca as aspas por que não receonhece nenhum caracter UTF-8 (acento)
        expect(@mailer.header['To'].to_s).to eq("emaildousuario@example.com")
      end
      it "should not have more than one to address" do
        expect(@mailer.to.size).to eq(1)
      end
      it "should consider CC on recipients address" do
        expect(@mailer.cc).to be_nil
      end
      it "should consider CC on recipients address" do
        expect(@mailer.bcc).to be_nil
      end
      it "should set correct header From" do
        # Ele coloca as aspas por que reconhece que existe um caracter UTF-8 (acento)
        expect(@mailer.header['From'].to_s).to eq("Info ContaCal <info@contacal.com.br>")
      end
      it "should not have more than one from address" do
        expect(@mailer.from.size).to eq(1)
      end
      it "should be multipart" do
        expect(@mailer.multipart?).to be_falsey
      end
      it "should set correct charset" do
        expect(@mailer.charset).to eq("UTF-8")
      end
      it "should set correct body for text html" do
        body = @mailer.body.to_s
        filename = Rails.root.join('spec','fixtures','mailers','reset_password_instructions.html')
        File.open(filename, 'w') {|f| f.write(body) } unless File.exists?(filename)
        expect(body).to eq(File.read(filename))
      end
      it "should set correct content type" do
        expect(@mailer.content_type).to eq("text/html; charset=UTF-8")
      end
      it "should deliver successfully" do
        expect { Devise::Mailer.reset_password_instructions(@user).deliver }.to_not raise_error
      end
      describe "and delivered" do
        it "should be added to the delivery queue" do
          expect { Devise::Mailer.reset_password_instructions(@user).deliver }.to change(ActionMailer::Base.deliveries,:size).by(1)
        end
      end
    end
  end
end