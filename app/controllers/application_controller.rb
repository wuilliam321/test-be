class ApplicationController < ActionController::Base
  include ControllerTokenUtilities

  prepend_before_action :must_be_authenticated

  def must_be_authenticated
    # If user is not authenticated, redirect to login
    # For use in before_actions
    authenticated = false
    if has_valid_auth_token?
      user = get_current_user
      if user
        authenticated = true
        Rails.logger.info('ACCESS_CONTROL') { "GRANTED: Authenticated" }
      else
        respond_to do |format|
          format.html { redirect_to login_path }
          format.json { render json: {:code => "login_required", :error => "Login required"}, status: :forbidden }
        end
        Rails.logger.info('ACCESS_CONTROL') { "DENIED: Not authenticated, session token is invalid" }
      end
    end
    authenticated
  end
end
