json.array!@clicks do |click|
  json.extract! click, :article_id, :click_x, :click_y, :button_url, :button_text, :view_ip, :created_at
end
