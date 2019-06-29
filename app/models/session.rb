class Session < ApplicationRecord
  def self.get_by_token(jwt_token)
    Session.find_by(token: jwt_token)
  end

  def pretty_user_info
    data = JSON.parse user_info
    {
        :id => data["id"],
        :last_name => data["lastName"],
        :name => data["name"],
        :country => data["country"]["id"]
    }
  end

end
