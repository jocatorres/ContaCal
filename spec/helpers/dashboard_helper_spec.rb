# -*- encoding : utf-8 -*-
require 'spec_helper'

describe DashboardHelper, type: :helper do
  let(:fixed_date) { Date.new(2011,8,20) }

  context '#display_daily_total' do
    context "there were no spent calories" do
      let(:user) do
        mock_user = double(:user)
        expect(mock_user).to receive(:spent_kcal).with(:date => fixed_date).and_return(0)
        expect(mock_user).to receive(:consumed_kcal).with(:date => fixed_date).and_return(123.4)
        mock_user
      end
      it "should return only consumed calories" do
        expect(display_daily_total(fixed_date)).to eq("123")
      end
    end

    context "there were spent calories" do
      let(:user) do
        mock_user = double(:user)
        expect(mock_user).to receive(:spent_kcal).with(:date => fixed_date).and_return(23)
        expect(mock_user).to receive(:consumed_kcal).with(:date => fixed_date).and_return(123.4)
        mock_user
      end
      it "should return the consumed, spent and net calories" do
        expect(display_daily_total(fixed_date)).to eq("123 ingeridas - 23 gastas = 100")
      end
    end
  end
end

