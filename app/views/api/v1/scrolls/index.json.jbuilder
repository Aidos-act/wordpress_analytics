json.array!@scrolls do |scroll|
  json.extract! scroll, :article_id, :scroll_pos, :scroll_dur, :created_at
end