require 'rails_helper'

RSpec.describe Search, type: :model do
  before(:all) do
    @search = Search.new(lat: '-34.9158592', lng: '-56.1923705', country: 1, session: Session.last)
    @search.save
  end

  it 'should gps_point return the right value' do
    result = @search.gps_point
    expect(result).to eq '-34.9158592,-56.1923705'
  end
end
