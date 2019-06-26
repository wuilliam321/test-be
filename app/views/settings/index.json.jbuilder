json.array! @settings do |setting|
  json.id setting.id
  json.lat setting.key
  json.lng setting.value
end