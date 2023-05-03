require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DashboardController, type: :routing do
  describe "routing" do
    it "recognizes and generates index" do
      expect({ get: "/" }).to route_to("dashboard#index")
      expect(root_path).to eq('/')
    end

    it "recognizes and generates authenticate" do
      expect({ get: "/authenticate" }).to route_to("dashboard#authenticate")
      expect(authenticate_path).to eq('/authenticate')
    end

    it "recognizes and generates index with date" do
      expect({ get: "/2011/08/24" }).to route_to("dashboard#index", :year => '2011', :month => '08', :day => '24')
      expect(dashboard_path(:year => '2011', :month => '08', :day => '24')).to eq('/2011/08/24')
    end

    it "recognizes and generates kcal_limit" do
      expect({ put: "/kcal_limit" }).to route_to("dashboard#update_kcal_limit")
      expect(kcal_limit_path).to eq('/kcal_limit')
    end

    it "recognizes and generates user_weight" do
      expect({ put: "/user_weight" }).to route_to("dashboard#update_user_weight")
      expect(user_weight_path).to eq('/user_weight')
    end

    it "recognizes and generates confirm" do
      expect({ get: "/autocomplete_food_name" }).to route_to("dashboard#autocomplete_food_name")
      expect(autocomplete_food_name_path).to eq("/autocomplete_food_name")
    end

    it "recognizes and generates report" do
      expect({ get: "/report" }).to route_to("dashboard#report")
      expect(report_path).to eq("/report")
    end
  end
end
