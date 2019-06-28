module ControllerSessionUtilities
  def login_user!(email, password)
    session = Session.find_by(email: email)
    # TODO Expiration date may be occurs, check that
    if session.nil?
      data = PedidosYa::User.login username: email, password: password
      if data["access_token"]
        session = Session.new
        session.token = data["access_token"]
        session.email = email
        session.save
      end
    end
    session
  end
end