require 'spec_helper'

describe ConfirmationController do
  render_views
  
  describe "GET index" do
    context "when user is not logged in" do
      it "should be success" do
        get :index
        response.should be_success
      end

      it "should render layout" do
        get :index
        response.should render_template("devise")
      end

      it "should render view" do
        get :index
        response.should render_template("confirmation/index")
      end
    end
  end
  
end
