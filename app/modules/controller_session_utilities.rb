module ControllerSessionUtilities
  def login_user!(email, password)
    py_client = pedidos_ya_client
    session = nil
    login_data = py_client.login email: email, password: password
    if login_data["access_token"]
      session = Session.new
      session.remote_token = login_data["access_token"]
      session.email = email
      session.save

      jwt_token = JsonWebToken.encode(id: session.id)
      set_session_token jwt_token

      user_data = py_client.user_info token: login_data["access_token"]
      session.user_info = user_data.to_json

      session.token = jwt_token
      session.save
    end
    @session = session
    session
  end

  def set_session_token(token)
    Rails.logger.info('ACCESS_CONTROL') {"Set session token"}
    if defined?(session)
      session[:jwt] = token
      request.headers['Authorization'] = token
    end
  end

  def get_session_token
    token = nil
    if !defined?(session)
      token = @session.token
    elsif request.format.html?
      if session[:jwt]
        Rails.logger.info('ACCESS_CONTROL') {"[html] Validating token found in session"}
        token = session[:jwt]
      else
        Rails.logger.info('ACCESS_CONTROL') {"[html] No token found in session"}
      end
    elsif request.format.json?
      if request.headers['Authorization']
        Rails.logger.info('ACCESS_CONTROL') {"[json] Validating token found in Authorization header"}
        header = request.headers['Authorization']
        header = header.split(' ').last if header
        begin
          decoded = JsonWebToken.decode(header)
          session = Session.find(decoded[:id])
          token = session.token
        rescue ActiveRecord::RecordNotFound => e
          render json: {errors: e.message}, status: :unauthorized
        rescue JWT::DecodeError => e
          render json: {errors: e.message}, status: :unauthorized
        end
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
    if defined?(current_session) && defined?(session)
      current_session = Session.find_by({token: session[:jwt]})
      current_session.update!(token: '')

      session[:jwt] = nil
    end
    @session = nil
  end

  def logout_user!
    remove_session_token
  end
end