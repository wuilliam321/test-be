require 'rails_helper'

RSpec.describe PedidosYa::Base, type: :model do
  it 'should api not be nil' do
    conn = PedidosYa::Base.api
    expect(conn).to_not be_nil
  end

  it 'should get_token return access_token' do
    token = PedidosYa::Base.get_token
    expect(token).to_not be_nil
  end

  it 'should get return invalid token if no query params provided' do
    res = PedidosYa::Base.get('tokens')
    expect(res["code"]).to eq "INVALID_TOKEN"
  end

  it 'should api fail if bad api url provided' do
    expect {PedidosYa::Base.api url: 'BAD_URL'}.to raise_error URI::InvalidURIError
  end
end
