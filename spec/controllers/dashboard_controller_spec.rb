require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
  controller do
    skip_before_action :must_be_authenticated
  end

  # before(:each) do
  #   @user = {
  #       :email => "test@gmail.com",
  #       :password => "123"
  #   }
  #   stub_token_requests
  #   stub_auth_requests(email: @user[:email], password: @user[:password])
  # end

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

end
