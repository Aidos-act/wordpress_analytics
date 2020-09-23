compareLineChart = @compareLineChart

compareLineChart.each do |current|
	key_array = ['page_view', 'user', 'new_user', 'bounce', 'session', 'avg_time_on_page', 'mcv']
	
	time = current[0].strftime("%H:%M")
	
	json.set! time do
		current.each_with_index do |aa, index|
			next if index == 0
			j = index -1
			json.set! key_array[j], aa
		end
	end
end