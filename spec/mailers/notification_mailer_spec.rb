# -*- encoding : utf-8 -*-
require 'spec_helper'

describe NotificationMailer do
  
  before(:each) do
    @user =  Factory.create(:user, :name => 'Nome do Usuario', :email => 'emaildousuario@example.com')
  end
  
  describe "beginning_of_day" do
    it "should render successfully" do
      lambda { NotificationMailer.beginning_of_day(@user) }.should_not raise_error
    end
    describe "rendered without error" do
      before(:each) do
        Timecop.freeze(2011,11,24) do
          Factory.create(:user_food, :user => @user, :meal => 'breakfast', :date => Date.new(2011,11,23))
          Factory.create(:user_food, :user => @user, :meal => 'breakfast', :date => Date.new(2011,11,23), :amount => 1.5)
          3.times { Factory.create(:user_food, :user => @user, :meal => 'lunch', :date => Date.new(2011,11,23)) }
          @mailer = NotificationMailer.beginning_of_day(@user)
        end
      end
      it "should set correct subject" do
        @mailer.subject.should == "Resumo de suas calorias em 23/11/2011"
      end
      it "should set correct header To" do
        # Ele não coloca as aspas por que não receonhece nenhum caracter UTF-8 (acento)
        @mailer.header['To'].to_s.should == "Nome do Usuario <emaildousuario@example.com>"
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
        @mailer.header['From'].to_s.should == "ContaCal <contato@contacal.com.br>"
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
        filename = Rails.root.join('spec','fixtures','mailers','beginning_of_day.html')
        File.open(filename, 'w') {|f| f.write(body) } unless File.exists?(filename)
        body.should == File.read(filename)
      end
      it "should set correct content type" do
        @mailer.content_type.should == "text/html; charset=UTF-8"
      end
      it "should deliver successfully" do
        lambda { NotificationMailer.beginning_of_day(@user).deliver }.should_not raise_error
      end
      describe "and delivered" do
        it "should be added to the delivery queue" do
          lambda { NotificationMailer.beginning_of_day(@user).deliver }.should change(ActionMailer::Base.deliveries,:size).by(1)
        end
      end
    end
    describe "without foods on a day" do
      before(:each) do
        Timecop.freeze(2011,11,25) do
          @mailer = NotificationMailer.beginning_of_day(@user)
        end
      end
      it "should set correct body for text html" do
        body = @mailer.body.to_s
        filename = Rails.root.join('spec','fixtures','mailers','beginning_of_day-without_food.html')
        File.open(filename, 'w') {|f| f.write(body) } unless File.exists?(filename)
        body.should == File.read(filename)
      end
    end
  end
  
  describe "end_of_day" do
    it "should render successfully" do
      lambda { NotificationMailer.end_of_day(@user) }.should_not raise_error
    end
    describe "rendered without error" do
      before(:each) do
        Timecop.freeze(2011,11,24) do
          Factory.create(:user_food, :user => @user, :meal => 'breakfast', :date => Date.new(2011,11,24))
          Factory.create(:user_food, :user => @user, :meal => 'breakfast', :date => Date.new(2011,11,24), :amount => 1.5)
          3.times { Factory.create(:user_food, :user => @user, :meal => 'lunch', :date => Date.new(2011,11,24)) }
          @mailer = NotificationMailer.end_of_day(@user)
        end
      end
      it "should set correct subject" do
        @mailer.subject.should == "Resumo de suas calorias de hoje (24/11/2011)"
      end
      it "should set correct header To" do
        # Ele não coloca as aspas por que não receonhece nenhum caracter UTF-8 (acento)
        @mailer.header['To'].to_s.should == "Nome do Usuario <emaildousuario@example.com>"
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
        @mailer.header['From'].to_s.should == "ContaCal <contato@contacal.com.br>"
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
        filename = Rails.root.join('spec','fixtures','mailers','end_of_day.html')
        File.open(filename, 'w') {|f| f.write(body) } unless File.exists?(filename)
        body.should == File.read(filename)
      end
      it "should set correct content type" do
        @mailer.content_type.should == "text/html; charset=UTF-8"
      end
      it "should deliver successfully" do
        lambda { NotificationMailer.end_of_day(@user).deliver }.should_not raise_error
      end
      describe "and delivered" do
        it "should be added to the delivery queue" do
          lambda { NotificationMailer.end_of_day(@user).deliver }.should change(ActionMailer::Base.deliveries,:size).by(1)
        end
      end
    end
    describe "without foods on a day" do
      before(:each) do
        Timecop.freeze(2011,11,24) do
          @mailer = NotificationMailer.end_of_day(@user)
        end
      end
      it "should set correct body for text html" do
        body = @mailer.body.to_s
        filename = Rails.root.join('spec','fixtures','mailers','end_of_day-without_food.html')
        File.open(filename, 'w') {|f| f.write(body) } unless File.exists?(filename)
        body.should == File.read(filename)
      end
    end
    describe "without kcal on day less tha 70% of limit" do
      before(:each) do
        Timecop.freeze(2011,11,24) do
          Factory.create(:user_food, :user => @user, :meal => 'breakfast', :date => Date.new(2011,11,24))
          @mailer = NotificationMailer.end_of_day(@user)
        end
      end
      it "should set correct body for text html" do
        body = @mailer.body.to_s
        filename = Rails.root.join('spec','fixtures','mailers','end_of_day-below_70percent.html')
        File.open(filename, 'w') {|f| f.write(body) } unless File.exists?(filename)
        body.should == File.read(filename)
      end
    end
    describe "without kcal limit" do
      before(:each) do
        Timecop.freeze(2011,11,24) do
          Factory.create(:user_food, :user => @user, :meal => 'breakfast', :date => Date.new(2011,11,24))
          @user.kcal_limit = nil
          @mailer = NotificationMailer.end_of_day(@user)
        end
      end
      it "should set correct body for text html" do
        body = @mailer.body.to_s
        filename = Rails.root.join('spec','fixtures','mailers','end_of_day-below_70percent.html')
        File.open(filename, 'w') {|f| f.write(body) } unless File.exists?(filename)
        body.should == File.read(filename)
      end
    end
    describe "with kcal limit = 0" do
      before(:each) do
        Timecop.freeze(2011,11,24) do
          Factory.create(:user_food, :user => @user, :meal => 'breakfast', :date => Date.new(2011,11,24))
          @user.kcal_limit = 0
          @mailer = NotificationMailer.end_of_day(@user)
        end
      end
      it "should set correct body for text html" do
        body = @mailer.body.to_s
        filename = Rails.root.join('spec','fixtures','mailers','end_of_day-below_70percent.html')
        File.open(filename, 'w') {|f| f.write(body) } unless File.exists?(filename)
        body.should == File.read(filename)
      end
    end
  end
  
  describe "new_food" do
    before(:each) do
      @food = Factory.create(:food)
    end
    it "should render successfully" do
      lambda { NotificationMailer.new_food(@user, @food) }.should_not raise_error
    end
    describe "rendered without error" do
      before(:each) do
        @mailer = NotificationMailer.new_food(@user, @food)
      end
      it "should set correct subject" do
        @mailer.subject.should == "Sugestão de novo alimento"
      end
      it "should set correct header To" do
        # Ele não coloca as aspas por que não receonhece nenhum caracter UTF-8 (acento)
        @mailer.header['To'].to_s.should == "ContaCal <contato@contacal.com.br>"
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
        @mailer.header['From'].to_s.should == "Nome do Usuario <emaildousuario@example.com>"
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
        filename = Rails.root.join('spec','fixtures','mailers','new_food.html')
        File.open(filename, 'w') {|f| f.write(body) } unless File.exists?(filename)
        body.should == File.read(filename)
      end
      it "should set correct content type" do
        @mailer.content_type.should == "text/html; charset=UTF-8"
      end
      it "should deliver successfully" do
        lambda { NotificationMailer.new_food(@user, @food).deliver }.should_not raise_error
      end
      describe "and delivered" do
        it "should be added to the delivery queue" do
          lambda { NotificationMailer.new_food(@user, @food).deliver }.should change(ActionMailer::Base.deliveries,:size).by(1)
        end
      end
    end
  end
end