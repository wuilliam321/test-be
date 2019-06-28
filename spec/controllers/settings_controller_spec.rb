require 'rails_helper'

RSpec.describe SettingsController, type: :controller do
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

  describe "GET #show" do
    it "returns http success" do
      get :show, params: {id: 1}
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #edit" do
    it "returns http success" do
      get :edit, params: {id: 1}
      expect(response).to have_http_status(:success)
    end
  end

end
