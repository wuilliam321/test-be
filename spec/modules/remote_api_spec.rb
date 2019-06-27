require 'rails_helper'

RSpec.describe RemoteApi, type: :model do
  describe 'when a new request instance is created' do
    it 'should not be nil' do
      instance = RemoteApi::Request.new
      expect(instance).to_not be nil
    end

    it 'should not be nil' do
      instance = RemoteApi::Request.new(url: "http://", client_id: 'testId', client_secret: 'secret')
      expect(instance).to_not be nil
    end
  end

  describe 'when a get_client_token is called with valid credentials' do
    before(:each) do
      @instance = RemoteApi::Request.new
    end

    it 'should return the client token' do
      instance = @instance.get_client_token
      expect(instance).to_not be nil
    end
  end
end
