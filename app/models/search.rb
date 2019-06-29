class Search < ApplicationRecord
  belongs_to :session
  validates :lat, :lng, presence: true
end
