json.array!@articles do |article|
	json.(article, :id, :title, :url, :maxpos, :created_at)
	json.click article.clicks, :article_id, :click_x, :click_y, :btn_url, :btn_text, :view_ip, :created_at
	json.scroll article.scrolls, :article_id, :scroll_pos, :scroll_dur, :created_at
end	
