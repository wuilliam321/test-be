module ControllerTokenUtilities

  def parse_auth_token
    @auth_token ||= nil
    unless @auth_token
      @auth_token = "THIS_IS_FAKE_TOKEN"
    end
    @auth_token
  end

  def clear_auth_token
    @auth_token = nil
    @current_user = nil
  end

  def get_current_user
    @current_user ||= nil
    unless @current_user
      token = parse_auth_token
      if token
        @current_user = Session.get_by_token token
      end
    end
    @current_user
  end

  def has_valid_auth_token?
    !parse_auth_token.nil?
  end
end

