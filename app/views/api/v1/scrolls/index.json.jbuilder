json.array! @scrolls do |scroll|
  json.extract! scroll, :article_id, :scroll_max_pos, :created_at
end

