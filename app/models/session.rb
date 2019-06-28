class Session < ApplicationRecord
  def self.get_by_token(token)
    Session.find_by(token: token)
  end
end
