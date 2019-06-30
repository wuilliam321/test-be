json.array! @searches do |search|
  json.id search.id
  json.lat search.lat
  json.lng search.lng
  json.merge! JSON.parse search.cached_response unless search.cached_response.nil?
end