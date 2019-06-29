require 'rails_helper'

RSpec.describe PedidosYa::User, type: :module do
  before(:each) do
    @user = {
        :email => "test@gmail.com",
        :password => "123"
    }
    stub_bad_token_requests
    stub_token_requests
    stub_auth_requests
    stub_my_account_requests
  end

  it 'should login response not be nil' do
    conn = PedidosYa::User.login username: @user[:email], password: @user[:password]
    expect(conn).to_not be_nil
  end

  it 'should user_info return details' do
    token = PedidosYa::User.user_info 'fake_api_token'
    expect(token).to_not be_nil
  end
end
