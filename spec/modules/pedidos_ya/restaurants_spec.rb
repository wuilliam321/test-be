require 'rails_helper'

RSpec.describe PedidosYa::Restaurants, type: :module do
  before(:each) do
    stub_token_requests
    stub_restaurants_requests
    @country_id = 1
    @point = "-34.9158592,-56.1923705"
  end

  it 'should return a list of restaurant on search' do
    res = PedidosYa::Restaurants.search country: @country_id, point: @point
    expect(res).to_not be_nil
    expect(res["data"]).to eq []
  end
end
