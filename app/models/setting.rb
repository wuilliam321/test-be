class Setting < ApplicationRecord
  validates :key, :value, presence: true
end
