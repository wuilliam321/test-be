class Session < ApplicationRecord
  def self.get_by_token(token)
    Session.last
  end
end
