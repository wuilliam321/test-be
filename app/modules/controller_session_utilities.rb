module ControllerSessionUtilities
  def login_user!(email, password)
    session = Session.find_by(email: email)
    data = PedidosYa::User.login username: email, password: password
    if data["access_token"]
      session = session || Session.new
      session.token = data["access_token"]
      session.email = email
      session.save
      set_session_token session.token
    end
    @session = session
    session
  end

  def set_session_token(token)
    Rails.logger.info('ACCESS_CONTROL') {"Set session token"}
    if defined?(session)
      session[:token] = token
    end
  end

  def get_session_token
    token = nil
    if !defined?(session)
      token = @session.token
    elsif request.format.html?
      if session[:token]
        Rails.logger.info('ACCESS_CONTROL') {"[html] Validating token found in session"}
        token = session[:token]
      else
        Rails.logger.info('ACCESS_CONTROL') {"[html] No token found in session"}
      end
    elsif request.format.json?
      if request.headers['Authorization']
        Rails.logger.info('ACCESS_CONTROL') {"[json] Validating token found in Authorization header"}
        token = request.headers['Authorization']
      else
        Rails.logger.info('ACCESS_CONTROL') {"[json] No token found"}
      end
    else
      Rails.logger.info('ACCESS_CONTROL') {"[#{request.format}] Not checking for auth token since format should not be allowed"}
      raise "Authentication check for specified format #{request.format} has not been implemented"
    end
    token
  end

  def remove_session_token
    Rails.logger.info('ACCESS_CONTROL') {"Remove session token"}
    Session.where({token: session[:token]}).delete_all
    session[:token] = nil
    @session = nil
  end

  def logout_user!
    remove_session_token
  end
end