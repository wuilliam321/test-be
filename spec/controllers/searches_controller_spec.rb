require 'rails_helper'

RSpec.describe SearchesController, type: :controller do
  controller do
    skip_before_action :must_be_authenticated
  end

  before(:all) do
    session = Session.new(email: 'test@gmail.com', token: '123', user_info: '{country => 1}')
    session.save
    @search = Search.new(lat: '-34.9158592', lng: '-56.1923705', country: 1, session: session)
    @search.save
  end

  before(:each) do
    stub_token_requests
    stub_restaurants_requests
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

  describe "When run_restaurant_search called" do
    it "returns http success" do
      result = controller.run_restaurant_search @search
      expect(result).to be_truthy
    end
  end

  describe "POST #create with run_restaurant_search = false" do
    before(:each) do
      @search.created_at = Time.now - 600.seconds
      @search.save
      allow(controller).to receive(:run_restaurant_search).and_raise(404)
    end
    [:html, :json].each do |format|
      it "returns http success #{format}" do
        post :create, params: {search: {lat: '-34.9158592', lng: '-56.1923705'}}, as: format
        expect(response).to have_http_status(400) if format == :json
        expect(response).to redirect_to(searches_url) if format == :html
      end
    end
  end

  describe "POST #create with run_restaurant_search = true" do
    before(:each) do
      @search.created_at = Time.now - 600.seconds
      @search.save
      allow(controller).to receive(:run_restaurant_search).and_return(true)
    end
    [:html, :json].each do |format|
      it "returns http success #{format}" do
        post :create, params: {search: {lat: '-34.9158592', lng: '-56.1923705'}}, as: format
        expect(response).to have_http_status(:success) if format == :json
        expect(response).to redirect_to(searches_url) if format == :html
      end
    end
  end

  # it 'should fail when using bad point as request' do
  #
  # end

end
