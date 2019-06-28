module ControllerTokenUtilities

  def clear_auth_token
    @auth_token = nil
    @session = nil
  end

  def get_current_session
    @session ||= nil
    unless @session
      token = get_session_token
      if token
        @session = Session.get_by_token token
      end
    end
    @session
  end

  def has_valid_auth_token?
    !!get_session_token
  end
end

