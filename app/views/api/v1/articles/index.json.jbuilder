json.array!@articles do |article|
	json.(article, :id, :title, :url, :created_at)
	json.click article.clicks, :article_id, :click_x, :click_y, :btn_id, :view_ip, :created_at
	json.scroll_duration article.scroll_durations, :article_id, :scroll_pos, :scroll_du, :created_at
	json.scroll article.scrolls, :article_id, :scroll_max_pos, :created_at
end	
