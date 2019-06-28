require 'rails_helper'

RSpec.describe Session, type: :model do
  before(:all) do
    session = Session.new(email: 'test@gmail.com', token: 'test')
    session.save
  end
  it 'should return session by token' do
    result = Session.get_by_token 'test'
    expect(result.token).to eq 'test'
  end
end
