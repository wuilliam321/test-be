module ControllerTokenUtilities

  def clear_auth_token
    @auth_token = nil
    @session = nil
  end

  def get_current_session
    session = nil
    token = get_session_token
    if token
      session = Session.get_by_token token
    end
    session
  end

  def has_valid_auth_token?
    !!get_session_token
  end

  def get_current_user
    session = get_current_session
    session.pretty_user_info
  end

end

