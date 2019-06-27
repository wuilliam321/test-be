module PedidosYa
  class Base
    class << self
      BASE = "#{ENV["API_REST_URL"]}"

      def api
        Faraday.new(url: BASE) do |faraday|
          faraday.response :logger
          faraday.adapter Faraday.default_adapter
        end
      end

      def get_token
        path = "tokens?clientId=#{ENV["CLIENT_ID"]}&clientSecret=#{ENV["CLIENT_SECRET"]}"
        begin
          res = api.get do |req|
            req.url path
            req.options.timeout = 5
          end
          data = JSON.parse res.body
          data["access_token"]
        rescue => e
          Rails.logger.error("#{e.class}") {"Failed to get_token: [#{e.class}] #{e.message}"}
        end
      end

      def get(path, query = {})
        response, status = get_json(path, query)
        status == 200 ? response : errors(response)
      end

      def errors(response)
        error = {errors: {status: response["status"], message: response["message"]}}
        response.merge(error)
      end

      def get_json(root_path, query = {})
        query_string = query.map {|k, v| "#{k}=#{v}"}.join("&")
        path = query.empty? ? root_path : "#{root_path}?#{query_string}"

        begin
          res = api.get do |req|
            req.url path
            req.options.timeout = 5
            req.headers['Authorization'] = self.get_token
          end

          [JSON.parse(res.body), res.status]
        rescue => e
          Rails.logger.error("#{e.class}") {"Failed to get_json: [#{e.class}] #{e.message}"}
        end
      end
    end
  end
end