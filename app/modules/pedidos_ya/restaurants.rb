module PedidosYa
  class Restaurants < Request
    class << self
      def search(country:, point:)
        self.get("search/restaurants", {country: country, point: point})
      end
    end
  end
end
