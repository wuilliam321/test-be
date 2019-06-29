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

  def stub_restaurants_requests
    stub_request(:any, /#{ENV['API_REST_DOMAIN']}/)
        .to_return(status: 200, body: '{"total":5,"max":100,"sort":"","count":5,"data":[]}', headers: {})
  end

  def login_test_user!
    current_session = Session.new(email: 'test@gmail.com', token: '123', user_info: '{country => 1}')
    current_session.user_info = {:id => 1, :last_name => 'test', :name => 'test', :country => {:id => 1}}.to_json
    current_session.save
    jwt_token = JsonWebToken.encode(id: current_session.id)
    current_session.token = jwt_token
    current_session.save
    request.headers['Authorization'] = jwt_token
    session[:jwt] = jwt_token
    current_session
  end
end
