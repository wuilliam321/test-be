module PedidosYa
  class User < Request
    class << self
      def login(username:, password:)
        begin
          self.get("tokens", {userName: username, password: password})
        rescue => e
          Rails.logger.error("#{e.class}") {"Failed to login: [#{e.class}] #{e.message}"}
        end
      end
    end
  end
end
