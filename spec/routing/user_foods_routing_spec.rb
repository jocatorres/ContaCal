require 'spec_helper'

describe UserFoodsController, type: :routing do
  describe "routing" do
    it "recognizes and generates update" do
      expect({ put: "/user_foods/1" }).to route_to("user_foods#update", :id => "1")
      expect(user_food_path(1)).to eq('/user_foods/1')
    end
    it "recognizes and generates create" do
      expect({ post: "/user_foods" }).to route_to("user_foods#create")
      expect(user_foods_path).to eq('/user_foods')
    end
    it "recognizes and generates destroy" do
      expect({ delete: "/user_foods/1" }).to route_to("user_foods#destroy", :id => "1")
      expect(user_food_path(1)).to eq('/user_foods/1')
    end
  end
end
