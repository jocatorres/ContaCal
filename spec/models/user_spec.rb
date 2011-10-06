# -*- encoding : utf-8 -*-
require 'spec_helper'

describe User do
  it { should have_many(:user_foods) }
  [:name, :email, :password, :password_confirmation, :remember_me, :cpf, :address_street_and_number, :address_city, :address_state, :address_zipcode, :kcal_limit, :subscribed_daily, :subscribed_weekly].each do |attr|
    it { should allow_mass_assignment_of(attr) }
  end

  it { should validate_presence_of(:name) }

  describe "send_weekly_notification!" do
    it "should not send e-mails to unsubscribed people" do
      @user = Factory.create(:user, :subscribed_weekly => false)
      lambda do
        User.send_weekly_notification!
      end.should_not change(ActionMailer::Base.deliveries, :count)
    end

    context "with subscribed people" do
      before(:each) do
        @user = Factory.create(:user, :subscribed_weekly => true)
      end

      it "should deliver e-mail to that people" do
        lambda do
          User.send_weekly_notification!
        end.should change(ActionMailer::Base.deliveries, :count).by(1)
      end

      describe "delivered e-mail" do
        before(:each) do
          User.send_weekly_notification!
          @email = ActionMailer::Base.deliveries.last
        end

        it "should deliver to the correct user" do
          @email.to.first.should == @user.email
        end

        it "should deliver the correct email" do
          @email.subject.should =~ /Resumo semanal de calorias consumidas/
        end
      end
    end
  end

  describe "send_beginning_of_day_notification!" do
    it "should not send e-mails to unsubscribed people" do
      @user = Factory.create(:user, :subscribed_daily => false)
      lambda do
        User.send_beginning_of_day_notification!
      end.should_not change(ActionMailer::Base.deliveries, :count)
    end

    context "with subscribed people" do
      before(:each) do
        @user = Factory.create(:user, :subscribed_daily => true)
      end

      it "should deliver e-mail to that people" do
        lambda do
          User.send_beginning_of_day_notification!
        end.should change(ActionMailer::Base.deliveries, :count).by(1)
      end

      describe "delivered e-mail" do
        before(:each) do
          User.send_beginning_of_day_notification!
          @email = ActionMailer::Base.deliveries.last
        end
        
        it "should deliver to the correct user" do
          @email.to.first.should == @user.email
        end

        it "should deliver the correct email" do
          @email.subject.should =~ /Resumo de suas calorias em/
        end
      end
    end
  end

  describe "send_end_of_day_notification!" do
    it "should not send e-mails to unsubscribed people" do
      @user = Factory.create(:user, :subscribed_daily => false)
      lambda do
        User.send_end_of_day_notification!
      end.should_not change(ActionMailer::Base.deliveries, :count)
    end

    context "with subscribed people" do
      before(:each) do
        @user = Factory.create(:user, :subscribed_daily => true)
      end

      it "should deliver e-mail to that people" do
        lambda do
          User.send_end_of_day_notification!
        end.should change(ActionMailer::Base.deliveries, :count).by(1)
      end

      describe "delivered e-mail" do
        before(:each) do
          User.send_end_of_day_notification!
          @email = ActionMailer::Base.deliveries.last
        end

        it "should deliver to the correct user" do
          @email.to.first.should == @user.email
        end

        it "should deliver the correct email" do
          @email.subject.should =~ /Resumo de suas calorias de hoje/
        end
      end
    end
  end

  describe "deliver_end_of_day_email?" do
    context "when kcal limit is nil" do
      before(:each) do
        @user = Factory.create(:user, :subscribed_daily => true, :kcal_limit => nil)
      end

      context "when consumed kcal is more or equal than 1000kcal" do
        it "should be false" do
          food = Factory.create(:food, :kcal => 1000)
          Factory.create(:user_food, :food => food, :user => @user)
          @user.deliver_end_of_day_email?.should be_false
        end
      end
      context "when consumed kcal is less than 1000kcal" do
        it "should be true" do
          @user.deliver_end_of_day_email?.should be_true
        end
      end
    end
    context "when kcal limit is zero" do
      before(:each) do
        @user = Factory.create(:user, :subscribed_daily => true, :kcal_limit => 0)
      end

      context "when consumed kcal is more or equal than 1000kcal" do
        it "should be false" do
          food = Factory.create(:food, :kcal => 1000)
          Factory.create(:user_food, :food => food, :user => @user)
          @user.deliver_end_of_day_email?.should be_false
        end
      end
      context "when consumed kcal is less than 1000kcal" do
        it "should be true" do
          @user.deliver_end_of_day_email?.should be_true
        end
      end
    end
    context "when person registered 70% or more of kcal diary limit" do
      before(:each) do
        @user = Factory.create(:user, :subscribed_daily => true, :kcal_limit => 1000)
        food = Factory.create(:food, :kcal => 700)
        Factory.create(:user_food, :food => food, :user => @user)
      end
      it "should be false" do
        @user.deliver_end_of_day_email?.should be_false
      end
    end
    context "when person registered less than 70% of kcal diary limit" do
      before(:each) do
        @user = Factory.create(:user, :subscribed_daily => true, :kcal_limit => 1000)
      end
      it "should be true" do
        @user.deliver_end_of_day_email?.should be_true
      end      
    end
    context "when kcal_limit is 0 and consumed kcal > 1000" do
      it "should be false" do
        @user = Factory.create(:user, :subscribed_daily => true, :kcal_limit => 0)
        food = Factory.create(:food, :kcal => 1300)
        Factory.create(:user_food, :food => food, :user => @user)
        @user.deliver_end_of_day_email?.should be_false
      end
    end
    context "when kcal_limit is 0 and consumed kcal < 1000" do
      it "should be true" do
        @user = Factory.create(:user, :subscribed_daily => true, :kcal_limit => 0)
        food = Factory.create(:food, :kcal => 900)
        Factory.create(:user_food, :food => food, :user => @user)
        @user.deliver_end_of_day_email?.should be_true
      end
    end
  end

  describe "subscribed_weekly scope" do
    context "when deleted_at is nil" do
      it "should not return user" do
        @user = Factory.create(:user, :subscribed_weekly => false, :deleted_at => nil)
        User.subscribed_weekly.should_not include(@user)
      end
      it "should return user" do
        @user = Factory.create(:user, :subscribed_weekly => true, :deleted_at => nil)
        User.subscribed_weekly.should include(@user)
      end
    end
    context "when deleted_at is not nil" do
      it "should not return user" do
        @user = Factory.create(:user, :subscribed_weekly => false, :deleted_at => Time.now)
        User.subscribed_weekly.should_not include(@user)
      end
      it "should not return user too" do
        @user = Factory.create(:user, :subscribed_weekly => true, :deleted_at => Time.now)
        User.subscribed_weekly.should_not include(@user)
      end
    end
  end

  describe "subscribed_daily scope" do
    context "when deleted_at is nil" do
      it "should not return user" do
        @user = Factory.create(:user, :subscribed_daily => false, :deleted_at => nil)
        User.subscribed_daily.should_not include(@user)
      end
      it "should return user" do
        @user = Factory.create(:user, :subscribed_daily => true, :deleted_at => nil)
        User.subscribed_daily.should include(@user)
      end
    end
    context "when deleted_at is not nil" do
      it "should not return user" do
        @user = Factory.create(:user, :subscribed_daily => false, :deleted_at => Time.now)
        User.subscribed_daily.should_not include(@user)
      end
      it "should not return user too" do
        @user = Factory.create(:user, :subscribed_daily => true, :deleted_at => Time.now)
        User.subscribed_daily.should_not include(@user)
      end
    end
  end

  describe "consumed_kcal" do
    before(:each) do
      @user = Factory.create(:user)
      @food1 = Factory.create(:food, :kcal => 300)
      @food2 = Factory.create(:food, :kcal => 100, :kind => 'b')
    end
    context "requesting for a day" do
      context "there is no food" do
        it "should return 0" do
          @user.consumed_kcal.should == 0
        end
      end
      context "there is one food eaten today and twice" do
        before(:each) do
          Factory.create(:user_food, :user => @user, :food => @food1, :date => Date.today, :meal => 'breakfast', :amount => 2)
          Factory.create(:user_food, :user => @user, :food => @food2, :date => Date.today, :meal => 'breakfast', :amount => 1)
        end
        context "no meal requested" do
          context "no kind requested" do
            it "should return the kcal of food" do
              @user.consumed_kcal.should == 700
            end
          end
          context "food eaten on kind requested" do
            it "should return the kcal of food" do
              @user.consumed_kcal(:kind => 'a').should == 600
            end            
          end
          context "food eaten on another kind not requested" do
            it "should return the kcal of food" do
              @user.consumed_kcal(:kind => 'b').should == 100
            end
            it "should return the kcal of food" do
              @user.consumed_kcal(:kind => 'c').should == 0
            end
          end
        end
        context "food eaten on meal requested" do
          it "should return the kcal of food" do
            @user.consumed_kcal(:meal => 'breakfast').should == 700
          end
        end
        context "food eaten on another meal not requested" do
          it "should return the kcal of food" do
            @user.consumed_kcal(:meal => 'lunch').should == 0
          end
        end
      end
      context "there is one food eaten another day" do
        before(:each) do
          Factory.create(:user_food, :user => @user, :food => @food1, :date => Date.new(2011,8,20), :meal => 'breakfast', :amount => 2)
        end
        context "no meal requested" do
          it "should return the kcal of food" do
            Timecop.freeze(2011,8,23) do
              @user.consumed_kcal.should == 0
            end
          end
        end
        context "food eaten on meal requested" do
          it "should return the kcal of food" do
            Timecop.freeze(2011,8,23) do
              @user.consumed_kcal(:meal => 'breakfast').should == 0
            end
          end
        end
        context "food eaten on another meal not requested" do
          it "should return the kcal of food" do
            Timecop.freeze(2011,8,23) do
              @user.consumed_kcal(:meal => 'lunch').should == 0
            end
          end
        end
      end
      context "there is one food eaten on requested day" do
        before(:each) do
          Factory.create(:user_food, :user => @user, :food => @food1, :date => Date.new(2011,8,20), :meal => 'breakfast', :amount => 2)
        end
        context "no meal requested" do
          it "should return the kcal of food" do
            @user.consumed_kcal(:date => Date.new(2011,8,20)).should == 600
          end
        end
        context "food eaten on meal requested" do
          it "should return the kcal of food" do
            @user.consumed_kcal(:date => Date.new(2011,8,20), :meal => 'breakfast').should == 600
          end
        end
        context "food eaten on another meal not requested" do
          it "should return the kcal of food" do
            @user.consumed_kcal(:date => Date.new(2011,8,20), :meal => 'lunch').should == 0
          end
        end
      end
      context "there is no food eaten on requested day" do
        before(:each) do
          Factory.create(:user_food, :user => @user, :food => @food1, :date => Date.new(2011,8,20), :meal => 'breakfast', :amount => 2)
        end
        context "no meal requested" do
          it "should return the kcal of food" do
            @user.consumed_kcal(:date => Date.new(2011,8,22)).should == 0
          end
        end
        context "food eaten on meal requested" do
          it "should return the kcal of food" do
            @user.consumed_kcal(:date => Date.new(2011,8,22), :meal => 'breakfast').should == 0
          end
        end
        context "food eaten on another meal not requested" do
          it "should return the kcal of food" do
            @user.consumed_kcal(:date => Date.new(2011,8,22), :meal => 'lunch').should == 0
          end
        end
      end
    end
  end
  describe "consumed_foods" do
    before(:each) do
      @user = Factory.create(:user)
      @food1 = Factory.create(:food, :kcal => 100)
      @food2 = Factory.create(:food, :kcal => 200)
    end
    context "requesting for a day" do
      context "there is no food" do
        it "should return 0" do
          @user.consumed_foods.should == []
        end
      end
      context "there is one food eaten today and twice" do
        before(:each) do
          @user_food1 = Factory.create(:user_food, :user => @user, :food => @food1, :date => Date.today, :meal => 'breakfast', :amount => 2)
          @user_food2 = Factory.create(:user_food, :user => @user, :food => @food2, :date => Date.today, :meal => 'breakfast', :amount => 2)
        end
        context "no meal requested" do
          it "should return the kcal of food" do
            @user.consumed_foods.should == [@user_food2, @user_food1]
          end
        end
        context "food eaten on meal requested" do
          it "should return the kcal of food" do
            @user.consumed_foods(:meal => 'breakfast').should == [@user_food2, @user_food1]
          end
        end
        context "food eaten on another meal not requested" do
          it "should return the kcal of food" do
            @user.consumed_foods(:meal => 'lunch').should == []
          end
        end
      end
      context "there is one food eaten another day" do
        before(:each) do
          @user_food1 = Factory.create(:user_food, :user => @user, :food => @food1, :date => Date.new(2011,8,20), :meal => 'breakfast', :amount => 2)
          @user_food2 = Factory.create(:user_food, :user => @user, :food => @food2, :date => Date.new(2011,8,20), :meal => 'breakfast', :amount => 2)
        end
        context "no meal requested" do
          it "should return the kcal of food" do
            Timecop.freeze(2011,8,23) do
              @user.consumed_foods.should == []
            end
          end
        end
        context "food eaten on meal requested" do
          it "should return the kcal of food" do
            Timecop.freeze(2011,8,23) do
              @user.consumed_foods(:meal => 'breakfast').should == []
            end
          end
        end
        context "food eaten on another meal not requested" do
          it "should return the kcal of food" do
            Timecop.freeze(2011,8,23) do
              @user.consumed_foods(:meal => 'lunch').should == []
            end
          end
        end
      end
      context "there is one food eaten on requested day" do
        before(:each) do
          @user_food1 = Factory.create(:user_food, :user => @user, :food => @food1, :date => Date.new(2011,8,20), :meal => 'breakfast', :amount => 2)
          @user_food2 = Factory.create(:user_food, :user => @user, :food => @food2, :date => Date.new(2011,8,20), :meal => 'breakfast', :amount => 2)
        end
        context "no meal requested" do
          it "should return the kcal of food" do
            @user.consumed_foods(:date => Date.new(2011,8,20)).should == [@user_food2, @user_food1]
          end
        end
        context "food eaten on meal requested" do
          it "should return the kcal of food" do
            @user.consumed_foods(:date => Date.new(2011,8,20), :meal => 'breakfast').should == [@user_food2, @user_food1]
          end
        end
        context "food eaten on another meal not requested" do
          it "should return the kcal of food" do
            @user.consumed_foods(:date => Date.new(2011,8,20), :meal => 'lunch').should == []
          end
        end
      end
      context "there is no food eaten on requested day" do
        before(:each) do
          @user_food1 = Factory.create(:user_food, :user => @user, :food => @food1, :date => Date.new(2011,8,20), :meal => 'breakfast', :amount => 2)
          @user_food2 = Factory.create(:user_food, :user => @user, :food => @food2, :date => Date.new(2011,8,20), :meal => 'breakfast', :amount => 2)
        end
        context "no meal requested" do
          it "should return the kcal of food" do
            @user.consumed_foods(:date => Date.new(2011,8,22)).should == []
          end
        end
        context "food eaten on meal requested" do
          it "should return the kcal of food" do
            @user.consumed_foods(:date => Date.new(2011,8,22), :meal => 'breakfast').should == []
          end
        end
        context "food eaten on another meal not requested" do
          it "should return the kcal of food" do
            @user.consumed_foods(:date => Date.new(2011,8,22), :meal => 'lunch').should == []
          end
        end
      end
    end
  end
  describe "destroy" do
    before(:each) do
      @user = Factory.create(:user)
    end
    it "should not delete from database" do
      expect do
        @user.destroy
      end.should_not change(User, :count)
    end
    it "should fill deleted_at field" do
      expect do
        Timecop.freeze(2011,8,23) { @user.destroy }
        @user.reload
      end.should change(@user, :deleted_at).from(nil).to(Time.new(2011,8,23))
    end
  end
  describe "last_week_history" do
    before(:each) do
      @user = Factory.create(:user)
      @food100a = Factory.create(:food, :kcal => 100, :kind => 'a')
      @food200a = Factory.create(:food, :kcal => 200, :kind => 'a')
      @food100b = Factory.create(:food, :kcal => 100, :kind => 'b')
      @food200b = Factory.create(:food, :kcal => 200, :kind => 'b')
      @food100c = Factory.create(:food, :kcal => 100, :kind => 'c')
      @food200c = Factory.create(:food, :kcal => 200, :kind => 'c')

      # 03/10/2011 - 300 Kcal (33% 33% 33%)
      Factory.create(:user_food, :user => @user, :food => @food100a, :date => '2011-10-03', :meal => 'breakfast', :amount => 1)
      Factory.create(:user_food, :user => @user, :food => @food100b, :date => '2011-10-03', :meal => 'breakfast', :amount => 1)
      Factory.create(:user_food, :user => @user, :food => @food100c, :date => '2011-10-03', :meal => 'breakfast', :amount => 1)

      # 04/10/2011 - 0 Kcal
      
      # 05/10/2011 - 200 Kcal (0% 0% 100%)
      Factory.create(:user_food, :user => @user, :food => @food100c, :date => '2011-10-05', :meal => 'breakfast', :amount => 2)

      # 06/10/2011 - 1.400 Kcal (57,14% 28,57% 14,29%)
      Factory.create(:user_food, :user => @user, :food => @food200a, :date => '2011-10-06', :meal => 'breakfast', :amount => 4)
      Factory.create(:user_food, :user => @user, :food => @food200b, :date => '2011-10-06', :meal => 'breakfast', :amount => 2)
      Factory.create(:user_food, :user => @user, :food => @food200c, :date => '2011-10-06', :meal => 'breakfast', :amount => 1)

      # 07/10/2011 - 200 Kcal (50% 50% 0%)
      Factory.create(:user_food, :user => @user, :food => @food100a, :date => '2011-10-07', :meal => 'breakfast', :amount => 1)
      Factory.create(:user_food, :user => @user, :food => @food100b, :date => '2011-10-07', :meal => 'breakfast', :amount => 1)

      # 08/10/2011 - 0 Kcal

      # 09/10/2011 - 2.000 Kcal (100% 0% 0%)
      Factory.create(:user_food, :user => @user, :food => @food100a, :date => '2011-10-09', :meal => 'breakfast', :amount => 20)
    end
    
    it "should return correct array of data" do
      Timecop.freeze(2011,10,10) do
        @user.last_week_history.should == {
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
        }
      end
    end
    
  end
end
