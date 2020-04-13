json.array!@clicks do |click|
  json.extract! click, :article_id, :click_x, :click_y, :btn_id, :view_ip, :created_at
end
