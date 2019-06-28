module PedidosYa
  class User < Request
    class << self
      def login(username:, password:)
        self.get("tokens", {userName: username, password: password})
      end

      def check_token
        self.get("myAccount", {})
      end
    end
  end
end
