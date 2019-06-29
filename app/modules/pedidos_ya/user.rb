module PedidosYa
  class User < Request
    class << self
      def login(username:, password:)
        self.get("tokens", {userName: username, password: password})
      end

      def user_info(token)
        self.get("myAccount", {}, token)
      end
    end
  end
end
