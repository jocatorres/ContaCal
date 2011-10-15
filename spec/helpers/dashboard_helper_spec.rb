# -*- encoding : utf-8 -*-
require 'spec_helper'

describe DashboardHelper do
  let(:fixed_date) { Date.new(2011,8,20) }

  context '#display_daily_total' do
    context "there were no spent calories" do
      let(:user) do
        mock_user = double(:user)
        mock_user.should_receive(:spent_kcal).with(:date => fixed_date).and_return(0)
        mock_user.should_receive(:consumed_kcal).with(:date => fixed_date).and_return(123.4)
        mock_user
      end
      it "should return only consumed calories" do
        display_daily_total(fixed_date).should == "123"
      end
    end

    context "there were spent calories" do
      let(:user) do
        mock_user = double(:user)
        mock_user.should_receive(:spent_kcal).with(:date => fixed_date).and_return(23)
        mock_user.should_receive(:consumed_kcal).with(:date => fixed_date).and_return(123.4)
        mock_user
      end
      it "should return the consumed, spent and net calories" do
        display_daily_total(fixed_date).should == "123 ingeridas - 23 gastas = 100"
      end
    end
  end
end

