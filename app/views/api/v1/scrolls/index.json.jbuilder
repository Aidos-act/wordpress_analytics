json.array!@scrolls do |scroll|
  json.extract! scroll, :article_id, :scroll_position, :scroll_duration, :created_at
end