# -*- encoding : utf-8 -*-
require 'spec_helper'

describe NotificationMailer do
  before(:each) do
    @user =  FactoryGirl.create(:user, :name => 'Nome do Usuario', :email => 'emaildousuario@example.com')
  end

  describe "welcome" do
    it "should render successfully" do
      expect { NotificationMailer.welcome(@user) }.to_not raise_error
    end
    describe "rendered without error" do
      before(:each) do
        @mailer = NotificationMailer.welcome(@user)
      end
      it "should set correct subject" do
        expect(@mailer.subject).to match(/Seja bem vindo ao ContaCal!/)
      end
      it "should set correct header To" do
        # Ele não coloca as aspas por que não receonhece nenhum caracter UTF-8 (acento)
        expect(@mailer.header['To'].to_s).to eq("Nome do Usuario <emaildousuario@example.com>")
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
        filename = Rails.root.join('spec','fixtures','mailers','welcome.html')
        File.open(filename, 'w') {|f| f.write(body) } unless File.exists?(filename)
        expect(body).to eq(File.read(filename))
      end
      it "should set correct content type" do
        expect(@mailer.content_type).to eq("text/html; charset=UTF-8")
      end
      it "should deliver successfully" do
        expect { NotificationMailer.welcome(@user).deliver }.to_not raise_error
      end
      describe "and delivered" do
        it "should be added to the delivery queue" do
          expect { 
            NotificationMailer.welcome(@user).deliver 
          }.to change(ActionMailer::Base.deliveries,:size).by(1)
        end
      end
    end
  end

  describe "weekly" do
    before(:each) do
      @user.stub(:last_week_history).and_return({
        :from => '2011-10-03'.to_date,
        :to => '2011-10-09'.to_date,
        :days => [
          {:day => '2011-10-03'.to_date, :kcal => 300.0, :percent_kind_a => 33.33, :percent_kind_b => 33.33, :percent_kind_c => 33.33},
          {:day => '2011-10-04'.to_date, :kcal => 0.0, :percent_kind_a => 0.0, :percent_kind_b => 0.0, :percent_kind_c => 0.0},
          {:day => '2011-10-05'.to_date, :kcal => 200.0, :percent_kind_a => 0.0, :percent_kind_b => 0.0, :percent_kind_c => 100.0},
          {:day => '2011-10-06'.to_date, :kcal => 1400.0, :percent_kind_a => 57.14, :percent_kind_b => 28.57, :percent_kind_c => 14.29},
          {:day => '2011-10-07'.to_date, :kcal => 200.0, :percent_kind_a => 50.0, :percent_kind_b => 50.0, :percent_kind_c => 0.0},
          {:day => '2011-10-08'.to_date, :kcal => 0.0, :percent_kind_a => 0.0, :percent_kind_b => 0.0, :percent_kind_c => 0.0},
          {:day => '2011-10-09'.to_date, :kcal => 2000.0, :percent_kind_a => 100.0, :percent_kind_b => 0.0, :percent_kind_c => 0.0},
        ]
      })
    end
    it "should render successfully" do
      expect { NotificationMailer.weekly(@user) }.to_not raise_error
    end
    describe "rendered without error" do
      before(:each) do
        @mailer = NotificationMailer.weekly(@user)
      end
      it "should set correct subject" do
        expect(@mailer.subject).to match(/Resumo semanal de calorias consumidas/)
      end
      it "should set correct header To" do
        # Ele não coloca as aspas por que não receonhece nenhum caracter UTF-8 (acento)
        expect(@mailer.header['To'].to_s).to eq("Nome do Usuario <emaildousuario@example.com>")
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
        filename = Rails.root.join('spec','fixtures','mailers','weekly.html')
        File.open(filename, 'w') {|f| f.write(body) } unless File.exists?(filename)
        expect(body).to eq(File.read(filename))
      end
      it "should set correct content type" do
        expect(@mailer.content_type).to eq("text/html; charset=UTF-8")
      end
      it "should deliver successfully" do
        expect { NotificationMailer.weekly(@user).deliver }.to_not raise_error
      end
      describe "and delivered" do
        it "should be added to the delivery queue" do
          expect { NotificationMailer.weekly(@user).deliver }.to change(ActionMailer::Base.deliveries,:size).by(1)
        end
      end
    end
  end

  describe "beginning_of_day" do
    it "should render successfully" do
      expect { NotificationMailer.beginning_of_day(@user) }.to_not raise_error
    end
    describe "rendered without error" do
      before(:each) do
        Timecop.freeze(2011,11,24) do
          FactoryGirl.create(:user_food, :user => @user, :meal => 'breakfast', :date => Date.new(2011,11,23))
          FactoryGirl.create(:user_food, :user => @user, :meal => 'breakfast', :date => Date.new(2011,11,23), :amount => 1.5)
          3.times { FactoryGirl.create(:user_food, :user => @user, :meal => 'lunch', :date => Date.new(2011,11,23)) }
          @mailer = NotificationMailer.beginning_of_day(@user)
        end
      end
      it "should set correct subject" do
        expect(@mailer.subject).to include("Resumo de suas calorias em 23/11/2011")
      end
      it "should set correct header To" do
        # Ele não coloca as aspas por que não receonhece nenhum caracter UTF-8 (acento)
        expect(@mailer.header['To'].to_s).to eq("Nome do Usuario <emaildousuario@example.com>")
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
        filename = Rails.root.join('spec','fixtures','mailers','beginning_of_day.html')
        File.open(filename, 'w') {|f| f.write(body) } unless File.exists?(filename)
        expect(body).to eq(File.read(filename))
      end
      it "should set correct content type" do
        expect(@mailer.content_type).to eq("text/html; charset=UTF-8")
      end
      it "should deliver successfully" do
        expect { NotificationMailer.beginning_of_day(@user).deliver }.to_not raise_error
      end
      describe "and delivered" do
        it "should be added to the delivery queue" do
          expect { NotificationMailer.beginning_of_day(@user).deliver }.to change(ActionMailer::Base.deliveries,:size).by(1)
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
        expect(body).to eq(File.read(filename))
      end
    end
  end
  
  describe "end_of_day" do
    it "should render successfully" do
      expect { NotificationMailer.end_of_day(@user) }.to_not raise_error
    end
    describe "rendered without error" do
      before(:each) do
        Timecop.freeze(2011,11,24) do
          FactoryGirl.create(:user_food, :user => @user, :meal => 'breakfast', :date => Date.new(2011,11,24))
          FactoryGirl.create(:user_food, :user => @user, :meal => 'breakfast', :date => Date.new(2011,11,24), :amount => 1.5)
          3.times { FactoryGirl.create(:user_food, :user => @user, :meal => 'lunch', :date => Date.new(2011,11,24)) }
          @mailer = NotificationMailer.end_of_day(@user)
        end
      end
      it "should set correct subject" do
        expect(@mailer.subject).to eq("Resumo de suas calorias de hoje (24/11/2011)")
      end
      it "should set correct header To" do
        # Ele não coloca as aspas por que não receonhece nenhum caracter UTF-8 (acento)
        expect(@mailer.header['To'].to_s).to eq("Nome do Usuario <emaildousuario@example.com>")
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
        filename = Rails.root.join('spec','fixtures','mailers','end_of_day.html')
        File.open(filename, 'w') {|f| f.write(body) } unless File.exists?(filename)
        expect(body).to eq(File.read(filename))
      end
      it "should set correct content type" do
        expect(@mailer.content_type).to eq("text/html; charset=UTF-8")
      end
      it "should deliver successfully" do
        expect { NotificationMailer.end_of_day(@user).deliver }.to_not raise_error
      end
      describe "and delivered" do
        it "should be added to the delivery queue" do
          expect { NotificationMailer.end_of_day(@user).deliver }.to change(ActionMailer::Base.deliveries,:size).by(1)
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
        expect(body).to eq(File.read(filename))
      end
    end
    describe "without kcal on day less tha 70% of limit" do
      before(:each) do
        Timecop.freeze(2011,11,24) do
          FactoryGirl.create(:user_food, :user => @user, :meal => 'breakfast', :date => Date.new(2011,11,24))
          @mailer = NotificationMailer.end_of_day(@user)
        end
      end
      it "should set correct body for text html" do
        body = @mailer.body.to_s
        filename = Rails.root.join('spec','fixtures','mailers','end_of_day-below_70percent.html')
        File.open(filename, 'w') {|f| f.write(body) } unless File.exists?(filename)
        expect(body).to eq(File.read(filename))
      end
    end
    describe "without kcal limit" do
      before(:each) do
        Timecop.freeze(2011,11,24) do
          FactoryGirl.create(:user_food, :user => @user, :meal => 'breakfast', :date => Date.new(2011,11,24))
          @user.kcal_limit = nil
          @mailer = NotificationMailer.end_of_day(@user)
        end
      end
      it "should set correct body for text html" do
        body = @mailer.body.to_s
        filename = Rails.root.join('spec','fixtures','mailers','end_of_day-below_70percent.html')
        File.open(filename, 'w') {|f| f.write(body) } unless File.exists?(filename)
        expect(body).to eq(File.read(filename))
      end
    end
    describe "with kcal limit = 0" do
      before(:each) do
        Timecop.freeze(2011,11,24) do
          FactoryGirl.create(:user_food, :user => @user, :meal => 'breakfast', :date => Date.new(2011,11,24))
          @user.kcal_limit = 0
          @mailer = NotificationMailer.end_of_day(@user)
        end
      end
      it "should set correct body for text html" do
        body = @mailer.body.to_s
        filename = Rails.root.join('spec','fixtures','mailers','end_of_day-below_70percent.html')
        File.open(filename, 'w') {|f| f.write(body) } unless File.exists?(filename)
        expect(body).to eq(File.read(filename))
      end
    end
  end
  
  describe "new_food" do
    before(:each) do
      @food = FactoryGirl.create(:food)
    end
    it "should render successfully" do
      expect { NotificationMailer.new_food(@user, @food) }.to_not raise_error
    end
    describe "rendered without error" do
      before(:each) do
        @mailer = NotificationMailer.new_food(@user, @food)
      end
      it "should set correct subject" do
        expect(@mailer.subject).to include("Sugestão de novo alimento")
      end
      it "should set correct header To" do
        # Ele não coloca as aspas por que não receonhece nenhum caracter UTF-8 (acento)
        expect(@mailer.header['To'].to_s).to eq("ContaCal <info@contacal.com.br>")
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
        expect(@mailer.header['From'].to_s).to eq("Nome do Usuario <emaildousuario@example.com>")
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
        filename = Rails.root.join('spec','fixtures','mailers','new_food.html')
        File.open(filename, 'w') {|f| f.write(body) } unless File.exists?(filename)
        expect(body).to eq(File.read(filename))
      end
      it "should set correct content type" do
        expect(@mailer.content_type).to eq("text/html; charset=UTF-8")
      end
      it "should deliver successfully" do
        expect { NotificationMailer.new_food(@user, @food).deliver }.to_not raise_error
      end
      describe "and delivered" do
        it "should be added to the delivery queue" do
          expect { NotificationMailer.new_food(@user, @food).deliver }.to change(ActionMailer::Base.deliveries,:size).by(1)
        end
      end
    end
  end
end