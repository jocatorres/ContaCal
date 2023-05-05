# -*- encoding : utf-8 -*-
require 'spec_helper'

describe User, type: :model do
  it { is_expected.to have_many(:user_foods) }
  it { is_expected.to validate_presence_of(:name) }

  describe "send_welcome_email after create" do
    it "should send e-mail to new user" do
      expect{ FactoryGirl.create(:user) }.to change(ActionMailer::Base.deliveries, :count).by(1)
    end

    describe "delivered e-mail" do
      before(:each) do
        @user = FactoryGirl.create(:user)
        @email = ActionMailer::Base.deliveries.last
      end

      it "should deliver to the correct user" do
        expect(@email.to.first).to eq(@user.email)
      end

      it "should deliver the correct email" do
        expect(@email.subject).to match(/Seja bem vindo ao ContaCal!/)
      end
    end
  end

  describe "send_weekly_notification!" do
    it "should not send e-mails to unsubscribed people" do
      @user = FactoryGirl.create(:user, :subscribed_weekly => false)
      expect {
        User.send_weekly_notification!
      }.to_not change(ActionMailer::Base.deliveries, :count)
    end

    context "with subscribed people" do
      before(:each) do
        @user = FactoryGirl.create(:user)
        @user.update(subscribed_weekly: true)
      end

      it "should deliver e-mail to that people" do
        expect {
          User.send_weekly_notification!
        }.to change(ActionMailer::Base.deliveries, :count).by(1)
      end

      describe "delivered e-mail" do
        before(:each) do
          User.send_weekly_notification!
          @email = ActionMailer::Base.deliveries.last
        end

        it "should deliver to the correct user" do
          expect(@email.to.first).to eq(@user.email)
        end

        it "should deliver the correct email" do
          expect(@email.subject).to match(/Resumo semanal de calorias consumidas/)
        end
      end
    end
  end

  describe "send_beginning_of_day_notification!" do
    it "should not send e-mails to unsubscribed people" do
      @user = FactoryGirl.create(:user)
      @user.update(subscribed_daily: false)
      expect {
        User.send_beginning_of_day_notification!
      }.to_not change(ActionMailer::Base.deliveries, :count)
    end

    context "with subscribed people" do
      before(:each) do
        @user = FactoryGirl.create(:user)
        @user.update(subscribed_daily: true)
      end

      it "should deliver e-mail to that people" do
        expect {
          User.send_beginning_of_day_notification!
        }.to change(ActionMailer::Base.deliveries, :count).by(1)
      end

      describe "delivered e-mail" do
        before(:each) do
          User.send_beginning_of_day_notification!
          @email = ActionMailer::Base.deliveries.last
        end
        
        it "should deliver to the correct user" do
          expect(@email.to.first).to eq(@user.email)
        end

        it "should deliver the correct email" do
          expect(@email.subject).to match(/Resumo de suas calorias em/)
        end
      end
    end
  end

  describe "send_end_of_day_notification!" do
    xit "should not send e-mails to unsubscribed people" do
      @user = FactoryGirl.create(:user)
      @user.update(subscribed_daily: false)
      expect {
        User.send_end_of_day_notification!
      }.to_not change(ActionMailer::Base.deliveries, :count)
    end

    context "with subscribed people" do
      before(:each) do
        @user = FactoryGirl.create(:user)
        @user.update(subscribed_daily: true)
      end

      xit "should deliver e-mail to that people" do
        expect {
          User.send_end_of_day_notification!
        }.to change(ActionMailer::Base.deliveries, :count).by(1)
      end

      describe "delivered e-mail" do
        before(:each) do
          User.send_end_of_day_notification!
          @email = ActionMailer::Base.deliveries.last
        end

        xit "should deliver to the correct user" do
          expect(@email.to.first).to eq(@user.email)
        end

        xit "should deliver the correct email" do
          expect(@email.subject).to match(/Resumo de suas calorias de hoje/)
        end
      end
    end
  end

  describe "deliver_end_of_day_email?" do
    context "when kcal limit is nil" do
      before(:each) do
        @user = FactoryGirl.create(:user, :kcal_limit => nil)
        @user.update(subscribed_daily: true)
      end

      context "when consumed kcal is more or equal than 1000kcal" do
        it "should be false" do
          food = FactoryGirl.create(:food, :kcal => 1000)
          FactoryGirl.create(:user_food, :food => food, :user => @user)
          
          expect(@user.deliver_end_of_day_email?).to be_falsey
        end
      end
      context "when consumed kcal is less than 1000kcal" do
        it "should be true" do
          expect(@user.deliver_end_of_day_email?).to be_truthy
        end
      end
    end
    context "when kcal limit is zero" do
      before(:each) do
        @user = FactoryGirl.create(:user, :kcal_limit => 0)
        @user.update(subscribed_daily: true)
      end

      context "when consumed kcal is more or equal than 1000kcal" do
        it "should be false" do
          food = FactoryGirl.create(:food, :kcal => 1000)
          FactoryGirl.create(:user_food, :food => food, :user => @user)
          
          expect(@user.deliver_end_of_day_email?).to be_falsey
        end
      end
      context "when consumed kcal is less than 1000kcal" do
        it "should be true" do
          expect(@user.deliver_end_of_day_email?).to be_truthy
        end
      end
    end
    
    context "when person registered 70% or more of kcal diary limit" do
      before(:each) do
        @user = FactoryGirl.create(:user, :kcal_limit => 1000)
        @user.update(subscribed_daily: true)
        food = FactoryGirl.create(:food, :kcal => 700)
        FactoryGirl.create(:user_food, :food => food, :user => @user)
      end
      it "should be false" do
        expect(@user.deliver_end_of_day_email?).to be_falsey
      end
    end
    context "when person registered less than 70% of kcal diary limit" do
      before(:each) do
        @user = FactoryGirl.create(:user, :kcal_limit => 1000)
        @user.update(subscribed_daily: true)
      end
      it "should be true" do
        expect(@user.deliver_end_of_day_email?).to be_truthy
      end      
    end
    context "when kcal_limit is 0 and consumed kcal > 1000" do
      it "should be false" do
        @user = FactoryGirl.create(:user, :kcal_limit => 0)
        @user.update(subscribed_daily: true)
        food = FactoryGirl.create(:food, :kcal => 1300)
        FactoryGirl.create(:user_food, :food => food, :user => @user)
        expect(@user.deliver_end_of_day_email?).to be_falsey
      end
    end
    context "when kcal_limit is 0 and consumed kcal < 1000" do
      it "should be true" do
        @user = FactoryGirl.create(:user, :kcal_limit => 0)
        @user.update(subscribed_daily: true)
        food = FactoryGirl.create(:food, :kcal => 900)
        FactoryGirl.create(:user_food, :food => food, :user => @user)
        expect(@user.deliver_end_of_day_email?).to be_truthy
      end
    end
  end

  describe "subscribed_weekly scope" do
    context "when deleted_at is nil" do
      it "should not return user" do
        @user = FactoryGirl.create(:user, :deleted_at => nil)
        @user.update(subscribed_weekly: false)
        expect(User.subscribed_weekly).to_not include(@user)
      end
      it "should return user" do
        @user = FactoryGirl.create(:user, :deleted_at => nil)
        @user.update(subscribed_weekly: true)
        expect(User.subscribed_weekly).to include(@user)
      end
    end
    context "when deleted_at is not nil" do
      it "should not return user" do
        @user = FactoryGirl.create(:user, :deleted_at => Time.now)
        @user.update(subscribed_weekly: false)
        expect(User.subscribed_weekly).to_not include(@user)
      end
      it "should not return user too" do
        @user = FactoryGirl.create(:user, :deleted_at => Time.now)
        @user.update(subscribed_weekly: true)
        expect(User.subscribed_weekly).to_not include(@user)
      end
    end
  end

  describe "subscribed_daily scope" do
    context "when deleted_at is nil" do
      it "should not return user" do
        @user = FactoryGirl.create(:user, :deleted_at => nil)
        @user.update(subscribed_daily: false)
        expect(User.subscribed_daily).to_not include(@user)
      end
      it "should return user" do
        @user = FactoryGirl.create(:user, :deleted_at => nil)
        @user.update(subscribed_daily: true)
        expect(User.subscribed_daily).to include(@user)
      end
    end
    context "when deleted_at is not nil" do
      it "should not return user" do
        @user = FactoryGirl.create(:user, :deleted_at => Time.now)
        @user.update(subscribed_daily: false)
        expect(User.subscribed_daily).to_not include(@user)
      end
      it "should not return user too" do
        @user = FactoryGirl.create(:user, :deleted_at => Time.now)
        @user.update(subscribed_daily: true)
        expect(User.subscribed_daily).to_not include(@user)
      end
    end
  end

  describe "consumed_kcal" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @food1 = FactoryGirl.create(:food, :kcal => 300)
      @food2 = FactoryGirl.create(:food, :kcal => 100, :kind => 'b')
    end
    context "requesting for a day" do
      context "there is no food" do
        it "should return 0" do
          expect(@user.consumed_kcal).to eq(0)
        end
      end
      context "there is one food eaten today and twice" do
        before(:each) do
          FactoryGirl.create(:user_food, :user => @user, :food => @food1, :date => Date.today, :meal => 'breakfast', :amount => 2)
          FactoryGirl.create(:user_food, :user => @user, :food => @food2, :date => Date.today, :meal => 'breakfast', :amount => 1)
        end
        context "no meal requested" do
          context "no kind requested" do
            it "should return the kcal of food" do
              expect(@user.consumed_kcal).to eq(700)
            end
          end
          context "food eaten on kind requested" do
            it "should return the kcal of food" do
              expect(@user.consumed_kcal(:kind => 'a')).to eq(600)
            end            
          end
          context "food eaten on another kind not requested" do
            it "should return the kcal of food" do
              expect(@user.consumed_kcal(:kind => 'b')).to eq(100)
            end
            it "should return the kcal of food" do
              expect(@user.consumed_kcal(:kind => 'c')).to eq(0)
            end
          end
        end
        context "food eaten on meal requested" do
          it "should return the kcal of food" do
           expect(@user.consumed_kcal(:meal => 'breakfast')).to eq(700)
          end
        end
        context "food eaten on another meal not requested" do
          it "should return the kcal of food" do
            expect(@user.consumed_kcal(:meal => 'lunch')).to eq(0)
          end
        end
      end
      context "there is one food eaten another day" do
        before(:each) do
          FactoryGirl.create(:user_food, :user => @user, :food => @food1, :date => Date.new(2011,8,20), :meal => 'breakfast', :amount => 2)
        end
        context "no meal requested" do
          it "should return the kcal of food" do
            Timecop.freeze(2011,8,23) do
              expect(@user.consumed_kcal).to eq(0)
            end
          end
        end
        context "food eaten on meal requested" do
          it "should return the kcal of food" do
            Timecop.freeze(2011,8,23) do
              expect(@user.consumed_kcal(:meal => 'breakfast')).to eq(0)
            end
          end
        end
        context "food eaten on another meal not requested" do
          it "should return the kcal of food" do
            Timecop.freeze(2011,8,23) do
              expect(@user.consumed_kcal(:meal => 'lunch')).to eq(0)
            end
          end
        end
      end
      context "there is one food eaten on requested day" do
        before(:each) do
          FactoryGirl.create(:user_food, :user => @user, :food => @food1, :date => Date.new(2011,8,20), :meal => 'breakfast', :amount => 2)
        end
        context "no meal requested" do
          it "should return the kcal of food" do
            expect(@user.consumed_kcal(:date => Date.new(2011,8,20))).to eq(600)
          end
        end
        context "food eaten on meal requested" do
          it "should return the kcal of food" do
            expect(@user.consumed_kcal(:date => Date.new(2011,8,20), :meal => 'breakfast')).to eq(600)
          end
        end
        context "food eaten on another meal not requested" do
          it "should return the kcal of food" do
            expect(@user.consumed_kcal(:date => Date.new(2011,8,20), :meal => 'lunch')).to eq(0)
          end
        end
      end
      context "there is no food eaten on requested day" do
        before(:each) do
          FactoryGirl.create(:user_food, :user => @user, :food => @food1, :date => Date.new(2011,8,20), :meal => 'breakfast', :amount => 2)
        end
        context "no meal requested" do
          it "should return the kcal of food" do
            expect(@user.consumed_kcal(:date => Date.new(2011,8,22))).to eq(0)
          end
        end
        context "food eaten on meal requested" do
          it "should return the kcal of food" do
            expect(@user.consumed_kcal(:date => Date.new(2011,8,22), :meal => 'breakfast')).to eq(0)
          end
        end
        context "food eaten on another meal not requested" do
          it "should return the kcal of food" do
            expect(@user.consumed_kcal(:date => Date.new(2011,8,22), :meal => 'lunch')).to eq(0)
          end
        end
      end
    end
  end
  describe "consumed_foods" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @food1 = FactoryGirl.create(:food, :kcal => 100)
      @food2 = FactoryGirl.create(:food, :kcal => 200)
    end
    context "requesting for a day" do
      context "there is no food" do
        it "should return 0" do
          expect(@user.consumed_foods).to eq([])
        end
      end
      context "there is one food eaten today and twice" do
        before(:each) do
          @user_food1 = FactoryGirl.create(:user_food, :user => @user, :food => @food1, :date => Date.today, :meal => 'breakfast', :amount => 2)
          @user_food2 = FactoryGirl.create(:user_food, :user => @user, :food => @food2, :date => Date.today, :meal => 'breakfast', :amount => 2)
        end
        context "no meal requested" do
          it "should return the kcal of food" do
            expect(@user.consumed_foods).to eq([@user_food2, @user_food1])
          end
        end
        context "food eaten on meal requested" do
          it "should return the kcal of food" do
            expect(@user.consumed_foods(:meal => 'breakfast')).to eq([@user_food2, @user_food1])
          end
        end
        context "food eaten on another meal not requested" do
          it "should return the kcal of food" do
            expect(@user.consumed_foods(:meal => 'lunch')).to eq([])
          end
        end
      end
      context "there is one food eaten another day" do
        before(:each) do
          @user_food1 = FactoryGirl.create(:user_food, :user => @user, :food => @food1, :date => Date.new(2011,8,20), :meal => 'breakfast', :amount => 2)
          @user_food2 = FactoryGirl.create(:user_food, :user => @user, :food => @food2, :date => Date.new(2011,8,20), :meal => 'breakfast', :amount => 2)
        end
        context "no meal requested" do
          it "should return the kcal of food" do
            Timecop.freeze(2011,8,23) do
              expect(@user.consumed_foods).to eq([])
            end
          end
        end
        context "food eaten on meal requested" do
          it "should return the kcal of food" do
            Timecop.freeze(2011,8,23) do
              expect(@user.consumed_foods(:meal => 'breakfast')).to eq([])
            end
          end
        end
        context "food eaten on another meal not requested" do
          it "should return the kcal of food" do
            Timecop.freeze(2011,8,23) do
              expect(@user.consumed_foods(:meal => 'lunch')).to eq([])
            end
          end
        end
      end
      context "there is one food eaten on requested day" do
        before(:each) do
          @user_food1 = FactoryGirl.create(:user_food, :user => @user, :food => @food1, :date => Date.new(2011,8,20), :meal => 'breakfast', :amount => 2)
          @user_food2 = FactoryGirl.create(:user_food, :user => @user, :food => @food2, :date => Date.new(2011,8,20), :meal => 'breakfast', :amount => 2)
        end
        context "no meal requested" do
          it "should return the kcal of food" do
            expect(@user.consumed_foods(:date => Date.new(2011,8,20))).to eq([@user_food2, @user_food1])
          end
        end
        context "food eaten on meal requested" do
          it "should return the kcal of food" do
            expect(@user.consumed_foods(:date => Date.new(2011,8,20), :meal => 'breakfast')).to eq([@user_food2, @user_food1])
          end
        end
        context "food eaten on another meal not requested" do
          it "should return the kcal of food" do
            expect(@user.consumed_foods(:date => Date.new(2011,8,20), :meal => 'lunch')).to eq([])
          end
        end
      end
      context "there is no food eaten on requested day" do
        before(:each) do
          @user_food1 = FactoryGirl.create(:user_food, :user => @user, :food => @food1, :date => Date.new(2011,8,20), :meal => 'breakfast', :amount => 2)
          @user_food2 = FactoryGirl.create(:user_food, :user => @user, :food => @food2, :date => Date.new(2011,8,20), :meal => 'breakfast', :amount => 2)
        end
        context "no meal requested" do
          it "should return the kcal of food" do
            expect(@user.consumed_foods(:date => Date.new(2011,8,22))).to eq([])
          end
        end
        context "food eaten on meal requested" do
          it "should return the kcal of food" do
            expect(@user.consumed_foods(:date => Date.new(2011,8,22), :meal => 'breakfast')).to eq([])
          end
        end
        context "food eaten on another meal not requested" do
          it "should return the kcal of food" do
            expect(@user.consumed_foods(:date => Date.new(2011,8,22), :meal => 'lunch')).to eq([])
          end
        end
      end
    end
  end
  describe "destroy" do
    before(:each) do
      @user = FactoryGirl.create(:user)
    end
    it "should not delete from database" do
      expect {
        @user.destroy
      }.to_not change(User, :count)
    end
    it "should fill deleted_at field" do
      expect {
        Timecop.freeze(2011,8,23) { @user.destroy }
        @user.reload
      }.to change(@user, :deleted_at).from(nil).to(Time.new(2011,8,23))
    end
  end
  describe "last_week_history" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @food100a = FactoryGirl.create(:food, :kcal => 100, :kind => 'a')
      @food200a = FactoryGirl.create(:food, :kcal => 200, :kind => 'a')
      @food100b = FactoryGirl.create(:food, :kcal => 100, :kind => 'b')
      @food200b = FactoryGirl.create(:food, :kcal => 200, :kind => 'b')
      @food100c = FactoryGirl.create(:food, :kcal => 100, :kind => 'c')
      @food200c = FactoryGirl.create(:food, :kcal => 200, :kind => 'c')

      # 03/10/2011 - 300 Kcal (33% 33% 33%)
      FactoryGirl.create(:user_food, :user => @user, :food => @food100a, :date => '2011-10-03', :meal => 'breakfast', :amount => 1)
      FactoryGirl.create(:user_food, :user => @user, :food => @food100b, :date => '2011-10-03', :meal => 'breakfast', :amount => 1)
      FactoryGirl.create(:user_food, :user => @user, :food => @food100c, :date => '2011-10-03', :meal => 'breakfast', :amount => 1)

      # 04/10/2011 - 0 Kcal
      
      # 05/10/2011 - 200 Kcal (0% 0% 100%)
      FactoryGirl.create(:user_food, :user => @user, :food => @food100c, :date => '2011-10-05', :meal => 'breakfast', :amount => 2)

      # 06/10/2011 - 1.400 Kcal (57,14% 28,57% 14,29%)
      FactoryGirl.create(:user_food, :user => @user, :food => @food200a, :date => '2011-10-06', :meal => 'breakfast', :amount => 4)
      FactoryGirl.create(:user_food, :user => @user, :food => @food200b, :date => '2011-10-06', :meal => 'breakfast', :amount => 2)
      FactoryGirl.create(:user_food, :user => @user, :food => @food200c, :date => '2011-10-06', :meal => 'breakfast', :amount => 1)

      # 07/10/2011 - 200 Kcal (50% 50% 0%)
      FactoryGirl.create(:user_food, :user => @user, :food => @food100a, :date => '2011-10-07', :meal => 'breakfast', :amount => 1)
      FactoryGirl.create(:user_food, :user => @user, :food => @food100b, :date => '2011-10-07', :meal => 'breakfast', :amount => 1)

      # 08/10/2011 - 0 Kcal

      # 09/10/2011 - 2.000 Kcal (100% 0% 0%)
      FactoryGirl.create(:user_food, :user => @user, :food => @food100a, :date => '2011-10-09', :meal => 'breakfast', :amount => 20)
    end
    
    it "should return correct array of data" do
      Timecop.travel(Time.zone.local(2011, 10, 10)) do
        expect(@user.last_week_history).to eq ({
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
    end
  end
  describe "and exercises." do
    subject     { FactoryGirl.create(:user) }
    let(:food1) { FactoryGirl.create(:food, :kcal => 300) }
    let(:food2) { FactoryGirl.create(:food, :kcal => 100, :kind => 'b') }
    let(:registered_date) { Date.new(2011,8,20) }
    let!(:registered_food1) { FactoryGirl.create(:user_food, :user => subject, :date => registered_date, :food => food1) }
    let!(:registered_food2) { FactoryGirl.create(:user_food, :user => subject, :date => registered_date, :food => food2) }

    context 'When there are no exercises registered' do
      it "#spent_kcal should be zero" do
        expect(subject.exercises(:date => registered_date)).to be_empty
        expect(subject.spent_kcal(:date => registered_date)).to be_zero
      end
    end
    context 'When the user has some exercise registered,' do
      let!(:registered_exercise) { FactoryGirl.create(:user_exercise, :user => subject, :date => registered_date) }
      
      let(:spent_kcal)    { subject.spent_kcal(:date => registered_date) }
      let(:consumed_kcal) { subject.consumed_kcal(:date => registered_date) }
      let(:net_kcal)      { subject.net_kcal(:date => registered_date) }

      it '#exercises should not be empty' do
        expect(subject.exercises(:date => registered_date)).to_not be_empty
      end
      it '#consumed_foods should not include exercises' do
        expect(subject.consumed_foods(:date => registered_date)).to_not include(registered_exercise)
      end
      it '#foods_and_exercises should include foods and exercises' do
        expect(subject.foods_and_exercises(:date => registered_date)).to include(registered_exercise, registered_food1, registered_food2)
      end
      it '#spent_kcal should be greater than zero' do
        expect(spent_kcal).to eq(registered_exercise.kcal)
      end
      it '#consumed_kcal should not affected' do
        expect(consumed_kcal).to eq(registered_food1.kcal + registered_food2.kcal)
      end
      it '#net_kcal should be #consumed_kcal - #spent_kcal' do
        expect(net_kcal).to eq(consumed_kcal - spent_kcal)
      end
    end
  end
end
