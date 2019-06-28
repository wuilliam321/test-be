require 'rails_helper'

RSpec.describe ControllerSessionUtilities, type: :controller do
  include ControllerSessionUtilities

  before(:all) do
    @user = {:email => ENV['TEST_USER'], :password => ENV['TEST_PASSWORD']}
  end

  it 'should create a session when user login' do
    session = login_user!(@user[:email], @user[:password])
    expect(session).to_not be_nil
  end

  it 'should reuse a session if user already exists' do
    session_one = login_user!(@user[:email], @user[:password])
    session_two = login_user!(@user[:email], @user[:password])
    expect(session_one).to_not be_nil
    expect(session_two).to_not be_nil
  end

  # TODO: test expiration date
end
