key_array = ['id', 'domain_name', 'article_title', 'article_url', 'page_view', 
				'user', 'new_user', 'bounce', 'session', 'avg_time_on_page', 'mcv']

json.array! @articleData do |article|
	article.each_with_index do |a, index|
		json.set! key_array[index], a
	end
end