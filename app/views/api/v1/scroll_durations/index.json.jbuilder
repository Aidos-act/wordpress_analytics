json.array!@scroll_durations do |scroll_duration|
  json.extract! scroll_duration, :article_id, :scroll_pos, :scroll_du, :created_at
end