require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  controller do
    skip_before_action :must_be_authenticated
  end

  before(:each) do
    @user = {
        :email => "test@gmail.com",
        :password => "123"
    }
    stub_token_requests
    stub_auth_requests(email: @user[:email], password: @user[:password])
  end

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #new without logged in" do
    [:html].each do |format|
      it "returns http success #{format}" do
        get :new, as: format
        expect(response).to render_template("new")
      end
    end
  end

  describe "GET #new already logged in" do
    [:html].each do |format|
      it "returns http success #{format}" do
        session[:token] = 'fake_user_token'
        get :new, as: format
        expect(response).to have_http_status(:success) if format == :json
        expect(response).to redirect_to(root_url) if format == :html
      end
    end
  end

  describe "POST #create" do
    [:html, :json].each do |format|
      it "returns http success #{format}" do
        post :create, params: {session: {email: @user[:email], password: @user[:password]}}, as: format
        expect(response).to have_http_status(:success) if format == :json
        expect(response).to redirect_to(dashboard_index_url) if format == :html
      end
    end
  end

  describe "GET #destroy" do
    [:html, :json].each do |format|
      it "returns http success #{format}" do
        delete :destroy, params: {id: ''}, as: format
        expect(response).to have_http_status(:success) if format == :json
        expect(response).to redirect_to(login_url) if format == :html
      end
    end
  end

end
