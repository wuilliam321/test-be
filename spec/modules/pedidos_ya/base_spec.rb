require 'rails_helper'

RSpec.describe PedidosYa::Base, type: :module do
  before(:each) do
    @user = {
        :email => "test@gmail.com",
        :password => "123"
    }
    stub_bad_token_requests
    stub_token_requests
    stub_auth_requests(email: @user[:email], password: @user[:password])
  end

  it 'should api not be nil' do
    conn = PedidosYa::Base.api
    expect(conn).to_not be_nil
  end

  it 'should get_api_token return access_token' do
    token = PedidosYa::Base.get_api_token
    expect(token).to_not be_nil
  end

  it 'should get return invalid token if no query params provided' do
    res = PedidosYa::Base.get('tokens')
    expect(res["code"]).to eq "INVALID_TOKEN"
  end

  it 'should api fail if bad api url provided' do
    expect {PedidosYa::Base.api url: 'BAD_URL'}.to raise_error URI::InvalidURIError
  end

  it 'should errors return object error' do
    response = {"status" => "404", "message" => "Not Found"}
    result = PedidosYa::Base.errors response
    expect(result[:errors][:status]).to eq "404"
    expect(result[:errors][:message]).to eq "Not Found"
  end
end
