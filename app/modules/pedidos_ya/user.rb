module PedidosYa
  class User < Request
    class << self
      def login(username:, password:)
        self.get("tokens", {userName: username, password: password})
      end
    end
  end
end
