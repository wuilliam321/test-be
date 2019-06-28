class Session < ApplicationRecord
  def self.get_by_token(jwt_token)
    Session.find_by(token: jwt_token)
  end
end
