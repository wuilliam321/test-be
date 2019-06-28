module ControllerTokenUtilities

  def clear_auth_token
    @auth_token = nil
    @current_user = nil
  end

  def get_current_user
    @current_user ||= nil
    unless @current_user
      token = get_session_token
      if token
        @current_user = Session.get_by_token token
      end
    end
    @current_user
  end

  def has_valid_auth_token?
    !!get_session_token
  end
end

