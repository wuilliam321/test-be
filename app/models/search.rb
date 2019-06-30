class Search < ApplicationRecord
  belongs_to :session
  validates :lat, :lng, :country, presence: true

  def gps_point
    "#{lat},#{lng}"
  end
end
