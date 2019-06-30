require 'net/http'

module PedidosYaAPI
  module V1
    class Client
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
        data = JSON.parse response.body
        set_user_token data["access_token"]
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

        JSON.parse response.body
      end

      def get_api_token
        params = {:clientId => ENV["CLIENT_ID"], :clientSecret => ENV["CLIENT_SECRET"]}
        response = client.get do |req|
          req.url 'tokens', params
          req.options.timeout = 10
        end
        data = JSON.parse response.body
        data["access_token"]
      end
    end
  end
end