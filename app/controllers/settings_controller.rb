class SettingsController < ApplicationController
  before_action :set_setting, only: [:edit, :update]

  def index
    @settings = Setting.all
  end

  def edit
  end

  def update
    @setting.assign_attributes(setting_params)

    if @setting.save
      respond_to do |format|
        format.html {redirect_to settings_url}
        format.json {render json: {error: 'Not Authorized'}, status: :forbidden}
      end
    else
      respond_to do |format|
        flash[:error] = @setting.errors.full_messages unless @setting.errors.full_messages.empty?
        flash[:error] = "Error while updating setting" if @setting.errors.full_messages.empty?
        format.html {redirect_to settings_url}
        format.json {render json: @setting.errors, status: :bad_request}
      end
    end
  end

  def set_setting
    id = params[:id] || params[:setting_id]
    begin
      @setting = Setting.find id
    rescue ActiveRecord::RecordNotFound
      respond_to do |format|
        format.html {render :file => "#{Rails.root}/public/404.html", :status => :not_found, :layout => false}
        format.json {render json: {error: "Not found"}, :status => :not_found}
      end
      return false
    end
  end

  def setting_params
    params.fetch(:setting, {}).permit(:value)
  end
end
