json.array! @searches do |search|
  json.id search.id
  json.lat search.lat
  json.lng search.lng
end