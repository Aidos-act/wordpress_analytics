json.(@article, :id, :article_title, :article_url, :max_position, :created_at)
json.click @article.clicks, :article_id, :click_x, :click_y, :button_url, :button_text, :created_at
json.scroll @article.scrolls, :article_id, :scroll_position, :scroll_duration, :created_at