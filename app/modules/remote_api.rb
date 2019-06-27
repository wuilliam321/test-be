module RemoteApi
  class Request
    def initialize(url: nil, client_id: nil, client_secret: nil)
      @url = url || ENV["API_REST_URL"]
      @client_id = client_id || ENV["CLIENT_ID"]
      @client_secret = client_secret || ENV["CLIENT_SECRET"]
    end
  end
end