module ControllerTestHelper
  def stub_token_requests
    stub_request(:any, /#{ENV['API_REST_DOMAIN']}/).to_return(status: 200, body: '{"access_token": "fake_api_token"}')
  end

  def stub_bad_token_requests
    stub_request(:any, /#{ENV['API_REST_DOMAIN']}/).to_return(status: 200, body: '{"code": "INVALID_TOKEN"}')
  end

  def stub_auth_requests
    stub_request(:any, /#{ENV['API_REST_DOMAIN']}/)
        .to_return(status: 200, body: '{"access_token": "fake_user_token"}', headers: {})
  end

  def stub_my_account_requests
    stub_request(:any, /#{ENV['API_REST_DOMAIN']}/)
        .to_return(status: 200, body: '{"id":1,"lastName":"Automation","name":"Test","country":{"id":1}}', headers: {})
  end
end
