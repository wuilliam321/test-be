require 'rails_helper'

RSpec.describe PedidosYa::User, type: :module do
  before(:each) do
    @user = {
        :email => "test@gmail.com",
        :password => "123"
    }
    stub_bad_token_requests
    stub_token_requests
    stub_auth_requests(email: @user[:email], password: @user[:password])
    stub_my_account_requests
  end

  it 'should login response not be nil' do
    conn = PedidosYa::User.login username: @user[:email], password: @user[:password]
    expect(conn).to_not be_nil
  end

  it 'should check token return valid token' do
    token = PedidosYa::User.check_token
    expect(token).to_not be_nil
  end
end
