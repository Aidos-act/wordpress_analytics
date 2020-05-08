require 'google/apis/analyticsreporting_v4'

class GetAnalytics

	VIEW_ID = "214644944"

	def initialize() 
		@view_id = VIEW_ID
		@analytics = Google::Apis::AnalyticsreportingV4
		auth
	end

	def get_data(startdate, enddate)
		puts startdate.class
		puts "2020-04-30".class
		date_range = @analytics::DateRange.new(start_date: startdate, end_date: enddate)
		# metric = @analytics::Metric.new(expression: 'ga:sessions')
		# metric = @analytics::Metric.new(expression: ['ga:sessions', 'ga:uniquePageviews'])
		# metric = @analytics::Metric.new
		# metric.expression = ['ga:sessions', 'ga:uniquePageviews']

		metrics = ['ga:pageviews', 'ga:uniquePageviews', 'ga:timeOnPage', 'ga:bounces', 'ga:entrances', 'ga:exits']
		metric_type = Array.new
		metrics.each do |m|
			metric = @analytics::Metric.new
			metric.expression = m
			metric_type.push(metric)
		end

		dimensions = ['ga:pagePath', 'ga:pageTitle']
		dimension_type = Array.new
		dimensions.each do |d|
			dimension  = @analytics::Dimension.new
			dimension.name = d
			dimension_type.push(dimension)
		end


		# dimension = @analytics::Dimension.new(name: 'ga:pagePath')

		dimension_filters = @analytics::DimensionFilterClause.new(
	      filters: [
	        @analytics::DimensionFilter.new(
	          dimension_name: 'ga:pagePath',
	          # operator: "EXACT",
	          # expressions: ['/archives/55244']
	          operator: "IN_LIST",
	          expressions: ['/archives/55244', '/archives/49795', '/archives/54087', '/archives/58437', '/archives/65171', '/archives/64435', '/archives/61533', '/archives/68924',
	          				'/archives/65086', '/archives/64736', '/archives/55244', '/archives/68211'
	          ]
	        )
	      ]
	    )

		request = @analytics::GetReportsRequest.new(
  			report_requests: [@analytics::ReportRequest.new(
    			view_id: @view_id, 
    			metrics: metric_type, 
    			dimension_filter_clauses: [dimension_filters],
    			dimensions: dimension_type,
    			# dimensions: [dimension], 
    			date_ranges: [date_range]
  			)]
		)
		response = @client.batch_get_reports(request)

		if !response.reports.first.data.rows then
			puts "error"
			key = "message"
			datahash[key.to_sym] = "no data"
		 	return datahash
		end


		data_from_google = response.reports.first.data.rows

		key_array = dimensions + metrics

		key_array.each_with_index do |k, index| 
			key_array[index] = k.gsub("ga:","")
		end

		set_ga_data_array = Array.new
	
		# data_from_google.each_with_index do |r, index|
			
			# puts "i am in here"
			# puts r.metrics.first.values[index]
			# puts index
			# puts r.dimensions[0]
			# puts "plz"
		
			# r.metrics.first.values.each_with_index do |m, index|
			# 	puts "i am in here"
			# 	puts key_array[index]
			# 	puts index
			# 	puts m
			# end
			# datahash[index] = r.dimensions
			# datahash[index].push(r.metrics.first.values)


		data_from_google.each_with_index do |r, index|

			datahash = {}
			i = 0;

			r.dimensions.each do |d|
				datahash[key_array[i]] = d
				i += 1
			end

			r.metrics.first.values.each do |m|
				datahash[key_array[i]] = m
				i += 1
			end

			set_ga_data_array.push(datahash)

		end

		return set_ga_data_array
	end

	def get_dropdown_data(startdate, enddate, selectedDrop)
		
		puts "2020-04-30".class
		date_range = @analytics::DateRange.new(start_date: startdate, end_date: enddate)
		metric = @analytics::Metric.new(expression: selectedDrop)
		if startdate == enddate then
			dimension = @analytics::Dimension.new(name: 'ga:hour')
			puts "hour"
		else
			dimension = @analytics::Dimension.new(name: 'ga:date')
			puts "day"
		end
		
		request = @analytics::GetReportsRequest.new(
  			report_requests: [@analytics::ReportRequest.new(
    			view_id: @view_id, 
    			metrics: [metric],
    			dimensions: [dimension],
    			date_ranges: [date_range]
  			)]
		)
		response = @client.batch_get_reports(request)
		datahash = {}

		if !response.reports.first.data.rows then
			puts "error"
			key = "message"
			datahash[key.to_sym] = "no data"
		 	return datahash
		end

		data_from_google = response.reports.first.data.rows
		
		data_from_google.each do |r|
			key = r.dimensions.first
			datahash[key.to_sym] = r.metrics.first.values
		end

		return datahash

	end

	def get_ranking_data(startdate, enddate)
		
		puts 'i am in ranking list'

		date_range = @analytics::DateRange.new(start_date: startdate, end_date: enddate)
		metric = @analytics::Metric.new(expression: 'ga:pageviews')
		dimension = @analytics::Dimension.new(name: 'ga:pagePath')
		order_by = @analytics::OrderBy.new(field_name: 'ga:pageviews', sort_order: 'DESCENDING')	

		dimension_filters = @analytics::DimensionFilterClause.new(
	      filters: [
	        @analytics::DimensionFilter.new(
	          dimension_name: 'ga:pagePath',
	          # operator: "EXACT",
	          # expressions: ['/archives/55244']
	          operator: "IN_LIST",
	          expressions: ['/archives/55244', '/archives/49795']
	        )
	      ]
	    )


		request = @analytics::GetReportsRequest.new(
  			report_requests: [@analytics::ReportRequest.new(
    			view_id: @view_id, 
    			metrics: [metric],
    			dimensions: [dimension],
    			dimension_filter_clauses: [dimension_filters],
    			date_ranges: [date_range],
    			order_bys: [order_by]
  			)]
		)

		response = @client.batch_get_reports(request)
		datahash = {}

		if !response.reports.first.data.rows then
			puts "error"
			key = "message"
			datahash[key.to_sym] = "no data"
		 	return datahash
		end

		data_from_google = response.reports.first.data.rows
		
		data_from_google.each do |r|
			key = r.dimensions.first
			datahash[key.to_sym] = r.metrics.first.values
		end

		return datahash

	end

	def get_article_data(startdate, enddate, selectedPath)

		date_range = @analytics::DateRange.new(start_date: startdate, end_date: enddate)

		metrics = ['ga:pageviews', 'ga:uniquePageviews', 'ga:timeOnPage', 'ga:bounces', 'ga:entrances', 'ga:exits']
		metric_type = Array.new
		metrics.each do |m|
			metric = @analytics::Metric.new
			metric.expression = m
			metric_type.push(metric)
		end

		dimensions = ['ga:pagePath', 'ga:pageTitle']
		dimension_type = Array.new
		dimensions.each do |d|
			dimension  = @analytics::Dimension.new
			dimension.name = d
			dimension_type.push(dimension)
		end


		# dimension = @analytics::Dimension.new(name: 'ga:pagePath')

		dimension_filters = @analytics::DimensionFilterClause.new(
	      filters: [
	        @analytics::DimensionFilter.new(
	          dimension_name: 'ga:pagePath',
	          operator: "EXACT",
	          expressions: [selectedPath]
	        )
	      ]
	    )

		request = @analytics::GetReportsRequest.new(
  			report_requests: [@analytics::ReportRequest.new(
    			view_id: @view_id, 
    			metrics: metric_type, 
    			dimension_filter_clauses: [dimension_filters],
    			dimensions: dimension_type,
    			date_ranges: [date_range]
  			)]
		)
		response = @client.batch_get_reports(request)

		if !response.reports.first.data.rows then
			puts "error"
			key = "message"
			datahash[key.to_sym] = "no data"
		 	return datahash
		end


		data_from_google = response.reports.first.data.rows

		key_array = dimensions + metrics

		key_array.each_with_index do |k, index| 
			key_array[index] = k.gsub("ga:","")
		end

		set_ga_data_array = Array.new

		data_from_google.each_with_index do |r, index|

			datahash = {}
			i = 0;

			r.dimensions.each do |d|
				datahash[key_array[i]] = d
				i += 1
			end

			r.metrics.first.values.each do |m|
				datahash[key_array[i]] = m
				i += 1
			end

			set_ga_data_array.push(datahash)

		end

		return set_ga_data_array
	end






	private


	def auth
		scope = ['https://www.googleapis.com/auth/analytics.readonly']
		@client = @analytics::AnalyticsReportingService.new
		@client.authorization = Google::Auth::ServiceAccountCredentials.make_creds(
		  json_key_io: File.open("#{Rails.root}/lib/google-auth-cred.json"),
		  scope: scope
		)
	end


end








# data = response.reports.first.data

# data.rows.each do |r|
# 	puts r.metrics.first.values
# 	puts r.dimensions
# end



# {:reports=>
# 	[{:column_header=>
# 		{:dimensions=>["ga:browser"], 
# 		 :metric_header=>
# 			{:metric_header_entries=>
# 				[{:name=>"sessions", 
# 				  :type=>"INTEGER"}]
# 			}
# 		}, 
# 	  :data=>
# 	  	{:maximums=>[{:values=>["11"]}], 
# 	  	 :minimums=>[{:values=>["2"]}], 
# 	  	 :row_count=>2, 
# 	  	 :rows=>
# 	  	 	[{:dimensions=>["Chrome"], 
# 	  	 	  :metrics=>
# 	  	 	  	[{:values=>["11"]}]
# 	  	 	 }, 
# 	  	 	 {:dimensions=>["Safari"], 
# 	  	 	  :metrics=>
# 	  	 	 	[{:values=>["2"]}]
# 	  	 	 }
# 	  	 	], 
# 	  	 :totals=>[{:values=>["13"]}]
# 	  	}}
# 	]
# }
