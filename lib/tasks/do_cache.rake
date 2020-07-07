namespace :do_cache do
  desc "TODO"
  task get_ga_data: :environment do
  	
  	require "#{Rails.root}/lib/get_analytics.rb"
  	require 'date'

  	# puts (Date.yesterday - 1.day).strftime("%Y-%m-%d")
  	api_data = GetAnalytics.new

  	# date = (Date.yesterday - 1.day).strftime("%Y-%m-%d")
  	# totalDates = date + '~' + date + 'total'

  	# if Rails.cache.read totalDates
  	# 	puts totalDates
  	# 	puts 'cache yes'
  	# else
  	# 	puts totalDates
  	# 	puts 'cache noooo'
  	# end
  	temp = Array.new
  	for i in 0..6 do
  		date = (Date.yesterday - i.day).strftime("%Y-%m-%d")
  		totalDates = date + '~' + date + 'temp'

		temp.push(totalDates)  		
  	end

  	temp.each do |d|

  		if Rails.cache.read d, namespace: "n1"
  			puts 'cache yes'
  		else
  			Rails.cache.write d, 'cache write', expires_in: 1.minutes, namespace: "n1"
  			puts 'cache no'
  		end
  	end


  	temp.each do |d|

  		if Rails.cache.read d, namespace: "n1"
  			puts 'cache yes'
  		else
  			
  			puts 'cache no'
  		end
  	end

  	# for i in 0..6 do
  	# 	date = (Date.yesterday - i.day).strftime("%Y-%m-%d")
  	# 	totalDates = date + '~' + date + 'total'

  	# 	# data = Rails.cache.fetch(totalDates, expires_in: 10.hour) do
	  #  #    data = api_data.get_total_ga_info(date, date)
	  #  #    puts totalDates
	  #  #  end

	  #   if !Rails.cache.read totalDates
	  #   	data = api_data.get_total_ga_info(date, date)
	  #   	Rails.cache.write totalDates, 'data', expires_in: 1.hour, namespace: "n1"
	  #   	puts totalDates
	  #   	puts 'hoon no...'
	  #   else
	  #   	puts totalDates
	  #   	puts 'hooon yesssss'
	  #   end

  	# end


  end

end
