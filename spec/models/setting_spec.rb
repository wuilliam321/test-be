require 'rails_helper'

RSpec.describe Setting, type: :model do
  before(:all) do
    @setting = Setting.new(key: 'refresh_time', value: '20')
    @setting.save
  end

  it 'should not be nil' do
    expect(@setting).to_not be_nil
  end
end
