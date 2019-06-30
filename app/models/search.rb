class Search < ApplicationRecord
  belongs_to :session
  validates :lat, :lng, presence: true

  def gps_point
    "#{lat},#{lng}"
  end
end
