module PedidosYa
  class Base
    class << self
      BASE = "#{ENV["API_REST_URL"]}"

      def api(url: nil)
        url = url || BASE
        Faraday.new(url: url) do |faraday|
          faraday.response :logger
          faraday.adapter Faraday.default_adapter
        end
      end

      def get_token(client_id: nil, client_secret: nil)
        path = "tokens"
        query_params = {
            :clientId => client_id || ENV["CLIENT_ID"],
            :clientSecret => client_secret || ENV["CLIENT_SECRET"]
        }

        res = api.get do |req|
          req.url path, query_params
          req.options.timeout = 5
        end
        data = JSON.parse res.body
        data["access_token"]
      end

      def get(path, query = {})
        response, status = get_json(path, query)
        status == 200 ? response : errors(response)
      end

      def errors(response)
        error = {errors: {status: response["status"], message: response["message"]}}
        response.merge(error)
      end

      def get_json(path, query = {})
        # query_string = query.map {|k, v| "#{k}=#{v}"}.join("&")
        # path = query.empty? ? root_path : "#{root_path}?#{query_string}"

        res = api.get do |req|
          req.url path, query
          req.options.timeout = 5
          req.headers['Authorization'] = self.get_token
        end

        [JSON.parse(res.body), res.status]
      end
    end
  end
end