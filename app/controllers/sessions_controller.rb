class SessionsController < ApplicationController
  skip_before_action :must_be_authenticated, :only => [:new, :create]

  def index
  end

  def new
    if has_valid_auth_token?
      respond_to do |format|
        format.html {redirect_to root_path}
        format.json {render json: {info: "Already logged in", authenticated: true}, status: :ok}
      end
    end
    @session = Session.new
    params[:password] = ''
  end

  def create
    login_user!(session_params[:email], session_params[:password])
    @session = Session.find_by(:email => session_params[:email])
    respond_to do |format|
      user_info = ''
      unless @session.user_info.nil?
        user_info = JSON.parse @session.user_info
        user_info["country"] = user_info["country"]["id"]
      end
      format.html {redirect_to dashboard_index_url}
      format.json {render json: {token: @session.token, user_info: user_info, authenticated: true}, status: :ok}
    end
  end

  def destroy
    logout_user!
    respond_to do |format|
      format.html {redirect_to login_url}
      format.json {render json: {info: "Logged out", authenticated: false}, status: :ok}
    end
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
