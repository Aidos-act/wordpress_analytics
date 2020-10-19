key_array = ['id', 'domain_name', 'article_title', 'article_url', 'page_view', 
				'bounce', 'session', 'avg_time_on_page', 'mcv', 'user', 'new_user']

json.array! @articleData do |article|
	article.each_with_index do |a, index|
		json.set! key_array[index], a
	end
end