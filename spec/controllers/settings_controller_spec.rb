require 'rails_helper'

RSpec.describe SettingsController, type: :controller do
  controller do
    skip_before_action :must_be_authenticated
  end

  before(:all) do
    @setting = Setting.new(key: 'test', value: 'test')
    @setting.save
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

  describe "GET #edit" do
    [:html, :json].each do |format|
      it "returns http success #{format}" do
        get :edit, params: {id: @setting.id}, as: format
        expect(response).to have_http_status(:success) if format == :json
        expect(response).to render_template(:edit) if format == :html
      end
    end
  end

  describe "PUT #update" do
    [:html, :json].each do |format|
      it "returns http success #{format}" do
        put :update, params: {id: @setting.id, setting: @setting.as_json}, as: format
        expect(response).to have_http_status(:forbidden) if format == :json
        expect(response).to redirect_to(settings_url) if format == :html
      end
    end
  end

end
