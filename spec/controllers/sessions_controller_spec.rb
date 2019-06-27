require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #new" do
    [:html, :json].each do |format|
      it "returns http success #{format}" do
        get :new
        expect(response.status).to eq 200
      end
    end
  end

  describe "GET #create" do
    it "returns http success" do
      get :create
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #destroy" do
    it "returns http success" do
      get :destroy, params: {id: 1}
      expect(response).to have_http_status(:success)
    end
  end

end
