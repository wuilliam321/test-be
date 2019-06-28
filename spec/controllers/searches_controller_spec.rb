require 'rails_helper'

RSpec.describe SearchesController, type: :controller do
  controller do
    skip_before_action :must_be_authenticated
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

end
