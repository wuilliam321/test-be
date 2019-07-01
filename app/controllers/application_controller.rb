class ApplicationController < ActionController::Base
  include ControllerTokenUtilities
  include ControllerSessionUtilities
  include PedidosYaAPI

  prepend_before_action :must_be_authenticated

  helper_method :pedidos_ya_client
  helper_method :get_current_user
  helper_method :has_valid_auth_token?

  protect_from_forgery with: :null_session, unless: -> {request.format.json?}

  def pedidos_ya_client
    @_client ||= PedidosYaAPI::V1::Client.new
  end

  def must_be_authenticated
    # If user is not authenticated, redirect to login
    # For use in before_actions
    authenticated = false
    if has_valid_auth_token?
      session = get_current_session
      if session
        authenticated = true
        Rails.logger.info('ACCESS_CONTROL') {"GRANTED: Authenticated"}
      end
    end
    unless authenticated
      Rails.logger.info('ACCESS_CONTROL') {"DENIED: Not authenticated, session token is invalid"}
      respond_to do |format|
        format.html {redirect_to new_session_path}
        format.json {render json: {:code => "login_required", :error => "Login required"}, status: :forbidden}
      end
    end
    authenticated
  end
end
