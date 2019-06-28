module ControllerTestHelper
  def login_user!(user: nil)
    session = Session.find_by(email: user[:email])
    # TODO Expiration date may be occurs, check that
    if session.nil?
      data = PedidosYa::User.login username: user[:email], password: user[:password]
      if data["access_token"]
        session = Session.new
        session.token = data["access_token"]
        session.email = user[:email]
        session.save
      end
    end
    session
  end
end
