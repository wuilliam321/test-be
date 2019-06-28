module ControllerTestHelper
  def stub_token_requests
    url = "#{ENV['API_REST_URL']}tokens?clientId=#{ENV['CLIENT_ID']}&clientSecret=#{ENV['CLIENT_SECRET']}"
    stub_request(:get, url)
        .with(
            headers: {
                'Accept' => '*/*',
                'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                'User-Agent' => 'Faraday v0.15.4'
            })
        .to_return(status: 200, body: '{"access_token": "fake_api_token"}')
  end

  def stub_bad_token_requests
    url = "#{ENV['API_REST_URL']}tokens"
    stub_request(:get, url)
        .with(
            headers: {
                'Accept' => '*/*',
                'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                'User-Agent' => 'Faraday v0.15.4'
            })
        .to_return(status: 200, body: '{"code": "INVALID_TOKEN"}')
  end

  def stub_auth_requests(email:, password:)
    stub_request(:get, "#{ENV['API_REST_URL']}tokens?password=#{password}&userName=#{email}")
        .with(
            headers: {
                'Accept' => '*/*',
                'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                'Authorization' => 'fake_api_token',
                'User-Agent' => 'Faraday v0.15.4'
            })
        .to_return(status: 200, body: '{"access_token": "fake_user_token"}', headers: {})

  end
end
