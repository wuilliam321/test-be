require 'rails_helper'

RSpec.describe SearchesController, type: :controller do
  controller do
    skip_before_action :must_be_authenticated
  end

  before(:each) do
    login_test_user!
  end

  describe "GET #index" do
    [:html, :json].each do |format|
      it "returns http success #{format}" do
        get :index, as: format
        expect(response).to have_http_status(:success) if format == :json
        expect(response).to render_template(:index) if format == :html
      end
    end
  end

  describe "GET #show" do
    before(:all) do
      @search = Search.new(lat: '-34.9158592', lng: '-56.1923705', country: 1, session: Session.last)
      @search.save
    end

    [:html, :json].each do |format|
      it "returns http success #{format}" do
        get :show, params: {id: @search.id}, as: format
        expect(response).to have_http_status(:success) if format == :json
        expect(response).to render_template(:show) if format == :html
      end
    end
  end

  describe "GET #show" do
    [:html, :json].each do |format|
      it "returns http success #{format}" do
        get :show, params: {id: "BAD_ID"}, as: format
        expect(response).to have_http_status(404)
      end
    end
  end

  describe "GET #new" do
    [:html].each do |format|
      it "returns http success #{format}" do
        get :new, as: format
        expect(response).to render_template(:new)
      end
    end
  end

  describe "POST #create" do
    [:html, :json].each do |format|
      it "returns http success #{format}" do
        post :create, params: {search: {lat: '-34.9158592', lng: '-56.1923705'}}, as: format
        expect(response).to have_http_status(:success) if format == :json
        expect(response).to redirect_to(searches_url) if format == :html
      end
    end
  end

  describe "POST #create with failing" do
    [:html, :json].each do |format|
      it "returns http success #{format}" do
        post :create, params: {search: {lat: nil, lng: nil}}, as: format
        expect(response).to have_http_status(400) if format == :json
        expect(response).to redirect_to(searches_url) if format == :html
      end
    end
  end

end
