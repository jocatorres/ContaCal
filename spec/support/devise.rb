module DeviseLoginTestHelper
  def login!
    @user = Factory.create(:user)
    sign_in @user
  end
end

RSpec.configure do |config|
  config.include Devise::TestHelpers, :type => :controller
  config.include DeviseLoginTestHelper, :type => :controller
end