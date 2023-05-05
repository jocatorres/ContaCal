require 'spec_helper'

describe FoodsController, type: :routing do
  describe "routing" do
    it "recognizes and generates new" do
      expect({ get: "/foods/new" }).to route_to("foods#new")
      expect(new_food_path).to eq('/foods/new')
    end
    it "recognizes and generates create" do
      expect({ post: "/foods" }).to route_to("foods#create")
      expect(foods_path).to eq('/foods')
    end
  end
end
