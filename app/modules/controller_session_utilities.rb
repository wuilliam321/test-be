module ControllerSessionUtilities
  def login_user!(email, password)
    session = Session.find_by(email: email)
    # TODO Expiration date may be occurs, check that
    # if session.nil?
      data = PedidosYa::User.login username: email, password: password
      if data["access_token"]
        session = session || Session.new
        session.token = data["access_token"]
        session.email = email
        session.save
        set_session_token session.token
      end
    # end
    @session = session
    session
  end

  def set_session_token(token)
    Rails.logger.info('ACCESS_CONTROL') { "Set session token" }
    if defined?(session)
      session[:token] = token
    end
  end

  def get_session_token
    Rails.logger.info('ACCESS_CONTROL') { "Get session token" }
    if defined?(session)
      session[:token]
    else
      @session.token
    end
  end

  def remove_session_token
    Rails.logger.info('ACCESS_CONTROL') { "Remove session token" }
    Session.where({token: session[:token]}).delete_all
    session[:token] = nil
    @session = nil
  end

  def logout_user!
    remove_session_token
  end
end