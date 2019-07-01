module PedidosYaAPI
  module V1
    class Client
      HTTP_OK_CODE = 200
      HTTP_BAD_REQUEST_CODE = 400
      HTTP_UNAUTHORIZED_CODE = 401
      HTTP_FORBIDDEN_CODE = 403
      HTTP_NOT_FOUND_CODE = 404
      HTTP_INTERNAL_SERVER_ERROR_CODE = 500

      APIExceptionError = Class.new(StandardError)
      BadRequestError = Class.new(APIExceptionError)
      UnauthorizedError = Class.new(APIExceptionError)
      ForbiddenError = Class.new(APIExceptionError)
      NotFoundError = Class.new(APIExceptionError)
      InternalServerError = Class.new(APIExceptionError)
      ApiError = Class.new(APIExceptionError)

      API_ENDPOINT = "#{ENV["API_REST_URL"]}".freeze

      attr_reader :api_token
      attr_reader :user_token

      def initialize
        @api_token = get_api_token
      end

      def set_user_token(token)
        @user_token = token
      end

      def restaurant(params:, token:)
        get_request(endpoint: "search/restaurants", params: params, token: token)
      end

      def login(email:, password:)
        @api_token = get_api_token
        params = {:userName => email, :password => password}
        response = client.get do |req|
          req.url 'tokens', params
          req.options.timeout = 10
          req.headers['Authorization'] = api_token
        end
        if response_successful?(response)
          data = JSON.parse response.body
          set_user_token data["access_token"]
        else
          raise error_class, "Code: #{response.status}, response: #{response.body}"
        end
        data
      end

      def user_info(token:)
        get_request(endpoint: "myAccount", params: {}, token: token)
      end

      private

      def client
        @_client ||= Faraday.new(url: API_ENDPOINT) do |client|
          client.response :logger
          client.adapter Faraday.default_adapter
        end
      end

      def get_request(endpoint:, params: {}, token:)
        response = client.get do |req|
          req.url endpoint, params
          req.options.timeout = 10
          req.headers['Authorization'] = token || user_token
        end

        if response_successful?(response)
          JSON.parse response.body
        else
          raise error_class, "Code: #{response.status}, response: #{response.body}"
        end
      end

      def get_api_token
        params = {:clientId => ENV["CLIENT_ID"], :clientSecret => ENV["CLIENT_SECRET"]}
        response = client.get do |req|
          req.url 'tokens', params
          req.options.timeout = 10
        end

        if response_successful?(response)
          data = JSON.parse response.body
          data["access_token"]
        else
          raise error_class, "Code: #{response.status}, response: #{response.body}"
        end
      end

      def error_class
        if defined?(response)
          case response.status
          when HTTP_BAD_REQUEST_CODE
            BadRequestError
          when HTTP_UNAUTHORIZED_CODE
            UnauthorizedError
          when HTTP_FORBIDDEN_CODE
            ForbiddenError
          when HTTP_NOT_FOUND_CODE
            NotFoundError
          when HTTP_INTERNAL_SERVER_ERROR_CODE
            InternalServerError
          else
            ApiError
          end
        else
          ApiError
        end
      end

      def response_successful?(response)
        if defined?(response)
          response.status == HTTP_OK_CODE
        else
          true
        end
      end
    end
  end
end