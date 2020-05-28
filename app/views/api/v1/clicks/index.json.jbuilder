json.array!@clicks do |click|
  json.extract! click, :article_id, :click_x, :click_y, :btn_url, :btn_text, :view_ip, :created_at
end
