require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
  before(:all) do
    @user = {:email => ENV['TEST_USER'], :password => ENV['TEST_PASSWORD']}
    login_user!(user: @user)
  end

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

end
