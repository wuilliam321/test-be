require 'jwt'

# Class to represent a decoded JWT token

# A class level utility function creates an encoded token from options
# An instance of this class is used to decode a token and read it's data

class JsonWebToken

  SECRET_KEY = Rails.application.secrets.secret_key_base. to_s

  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new decoded
  end
end
