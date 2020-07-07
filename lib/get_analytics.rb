require 'google/apis/analyticsreporting_v4'
require 'date'

class GetAnalytics < ApplicationController

	VIEW_ID = "214644944"

	# initialize 
	def initialize() 
		@view_id = VIEW_ID
		@analytics = Google::Apis::AnalyticsreportingV4
		auth
	end

	# total data by selected period
	def get_total_ga_info(startdate, enddate, hostname)
		puts 'totla data'
		set_total_by_date = Array.new

		formatted_startdate = DateTime.parse(startdate)
		formatted_enddate = DateTime.parse(enddate)
		

		# index 0 -> total data, index 1 -> data by date or hour
		current_arr = set_api_by_date(startdate, enddate, hostname)
		current_data = current_arr[0]
		current_linechart_data = current_arr[1]
		
		# get compare dates
		if startdate == enddate then
			compare_startdate = (formatted_startdate - 1.day).strftime("%Y-%m-%d")
			compare_enddate = (formatted_enddate - 1.day).strftime("%Y-%m-%d")
		else
			diff = (formatted_enddate - formatted_startdate).to_i + 1
			compare_startdate = (formatted_startdate - diff.days).strftime("%Y-%m-%d")
			compare_enddate = (formatted_enddate - diff.days).strftime("%Y-%m-%d")
		end	

		# index 0 -> total data, index 1 -> data by date or hour
		compare_arr = set_api_by_date(compare_startdate, compare_enddate, hostname)
		compare_data = compare_arr[0]
		compare_linechart_data = compare_arr[1]
		

		set_total_by_date.push(current_data)
		set_total_by_date.push(compare_data)
		set_total_by_date.push(current_linechart_data)
		set_total_by_date.push(compare_linechart_data)

		return set_total_by_date
	end


	# total data by dates
	def set_api_by_date(startdate, enddate, hostname)

		# setup date range
		date_range = @analytics::DateRange.new(start_date: startdate, end_date: enddate)

		# set metircs data. 10 metrices are allowed per one request
		metrics = ['ga:pageviews', 'ga:users', 'ga:bounces', 'ga:sessions',
				   'ga:avgTimeOnPage', 'ga:newUsers', 'ga:goal1ConversionRate', 'ga:goal1Completions'
				  ]

		# make new array and put metric type data in the array
		metric_type = Array.new
		metrics.each do |m|
			metric = @analytics::Metric.new
			metric.expression = m
			metric_type.push(metric)
		end

		
		# if startdate == enddate then
		# 	dimension = @analytics::Dimension.new(name: 'ga:hour')
		# 	order_by = @analytics::OrderBy.new(field_name: 'ga:hour', sort_order: 'ASCENDING')
		# else
		# 	dimension = @analytics::Dimension.new(name: 'ga:date')
		# 	order_by = @analytics::OrderBy.new(field_name: 'ga:date', sort_order: 'ASCENDING')
		# end


	 	# set dimensions, dimension_filters by hostname. if hostname is total, then set only hour or date in dimension

	 	if hostname == 'total'
			if startdate == enddate then
				dimensions = ['ga:hour']
			else
				dimensions = ['ga:date']
			end	 		
	 	else
	 		if startdate == enddate then
				dimensions = ['ga:hour', 'ga:hostname']
			else
				dimensions = ['ga:date', 'ga:hostname']
			end	
	 		dimension_filters = @analytics::DimensionFilterClause.new(
		      filters: [
		        @analytics::DimensionFilter.new(
		          dimension_name: 'ga:hostname',
		          not: false,
		          operator: "IN_LIST",
		          expressions: [hostname]
		        )
		      ]
		    )
	 	end

	 	dimension_type = Array.new
		dimensions.each do |d|
			dimension  = @analytics::Dimension.new
			dimension.name = d
			dimension_type.push(dimension)
		end			

		#set order_bys
		order_by = @analytics::OrderBy.new(field_name: dimensions[0], sort_order: 'ASCENDING')


		# setup request with the data i set up above to google analytics server
		request = @analytics::GetReportsRequest.new(
  			report_requests: [@analytics::ReportRequest.new(
    			view_id: @view_id, 
    			metrics: metric_type,
    			dimensions: dimension_type,
    			dimension_filter_clauses: [dimension_filters],
    			date_ranges: [date_range],
    			order_bys: [order_by]
  			)]
		)

		# send request and get the result in the response
		response = @client.batch_get_reports(request)

		# make new array for the total data. it will has datahash and dropdwnhash, datahash is for total data and
		# the other is for hourly/daily data. key would be time(00,01,02,...) or date(i.e. 5/20.5/21,...). 
		set_total_array = Array.new

		# this data is mcv and it is from database
		total_clicks_count = set_total_article(startdate, enddate)


		# getting total data part start

		total_data = response.reports.first.data.totals
		key_array = metrics
		# get rid of 'ga:'
		key_array.each_with_index do |k, index| 
			key_array[index] = k.gsub("ga:","")
		end

		total_data.each do |t|
			datahash = {}

			t.values.each_with_index do |v, index|
				datahash[key_array[index]] = v	
			end
			datahash['mcv'] = total_clicks_count
			set_total_array.push(datahash)
		end
		# datahash sample -> { "pageviews": "11", "users": "22", "bounces": "33", ... , "mcv": 0 }

		# getting total data part end

		# getting daily or hourly data part start
		dropdwnhash = {}

		data_from_google = response.reports.first.data.rows
		
		data_from_google.each do |r|
			vhash = {}
			# key would be hour or date
			key = r.dimensions.first

			# vhash is the data such as pageview, users and so on for specific time or date
			r.metrics.first.values.each_with_index do |v, index|
				vhash[key_array[index]] = v
			end

			if startdate == enddate
				key = key + ":00"
			end
			
			dropdwnhash[key.to_sym] = vhash
		end

		# dropdwnhash sample (hour) -> "00:00": { "pageviews": "534", "users": "478", "bounces": "432", ... },  "01:00": { ... }
		# dropdwnhash sample (date) -> "20200608": { "pageviews": "534", "users": "478", "bounces": "432", ... },  "20200609": { ... }

		set_total_array.push(dropdwnhash)

		# getting daily or hourly data part end

		return set_total_array
	end

	# get mcv date from database
	def set_total_article(startdate, enddate)
		start_date = startdate.to_date.beginning_of_day
	    end_date = enddate.to_date.end_of_day
		total_clicks_count = Click.where(:created_at => start_date..end_date).count
		return total_clicks_count
	end


	# each article data by selected period
	def get_data(startdate, enddate)
		
		date_range = @analytics::DateRange.new(start_date: startdate, end_date: enddate)
		order_by = @analytics::OrderBy.new(field_name: 'ga:pageviews', sort_order: 'DESCENDING')
		# metric = @analytics::Metric.new(expression: 'ga:sessions')
		# metric = @analytics::Metric.new(expression: ['ga:sessions', 'ga:uniquePageviews'])
		# metric = @analytics::Metric.new
		# metric.expression = ['ga:sessions', 'ga:uniquePageviews']
		
		metrics = ['ga:pageviews', 'ga:users', 'ga:bounces', 'ga:sessions',
				   'ga:avgTimeOnPage', 'ga:newUsers', 'ga:goal1ConversionRate', 'ga:goal1Completions'
				  ]


		metric_type = Array.new
		metrics.each do |m|
			metric = @analytics::Metric.new
			metric.expression = m
			metric_type.push(metric)
		end

		dimensions = ['ga:dateHour','ga:pagePath', 'ga:pageTitle', 'ga:hostname' ]
		dimension_type = Array.new
		dimensions.each do |d|
			dimension  = @analytics::Dimension.new
			dimension.name = d
			dimension_type.push(dimension)
		end


		# dimension = @analytics::Dimension.new(name: 'ga:pagePath')

		# dimension_filters = @analytics::DimensionFilterClause.new(
	 #      filters: [
	 #        @analytics::DimensionFilter.new(
	 #          dimension_name: 'ga:pagePath',
	 #          operator: "IN_LIST",
	 #          expressions: ['/archives/69839', '/archives/54087', '/archives/68924', '/archives/58437', '/archives/65171', '/archives/64435', '/archives/61533', '/archives/68924',
	 #          				'/archives/65086', '/archives/64736', '/archives/55244', '/archives/68211'
	 #          ]
	 #        )
	 #      ]
	 #    )

		request = @analytics::GetReportsRequest.new(
  			report_requests: [@analytics::ReportRequest.new(
    			view_id: @view_id, 
    			metrics: metric_type, 
    			dimensions: dimension_type,
    			# dimension_filter_clauses: [dimension_filters],
    			# dimensions: [dimension], 
    			date_ranges: [date_range],
    			order_bys: [order_by]
  			)]
		)
		response = @client.batch_get_reports(request)
		messageHash = {}

		# handling error 
		if !response.reports.first.data.rows then
			
			key = "message"
			messageHash[key.to_sym] = "no data"
		 	return messageHash
		end


		data_from_google = response.reports.first.data.rows

		key_array = dimensions + metrics

		# get rid of 'ga:'
		key_array.each_with_index do |k, index| 
			key_array[index] = k.gsub("ga:","")
		end

		key_array.push('id')
		key_array.push('clickCount')

		set_ga_data_array = Array.new


		data_from_google.each_with_index do |r, index|

			datahash = {}
			i = 0;

			# setup dimension part
			r.dimensions.each do |d|
				datahash[key_array[i]] = d
				i += 1
			end

			# setup metrics part
			r.metrics.first.values.each do |m|
				datahash[key_array[i]] = m
				i += 1
			end

			
			# get aticle data from db
			articleArr = set_article_data(datahash['hostname'], datahash['pagePath'], startdate, enddate)

			# setup id, mcv
			articleArr.each do |a|
				datahash[key_array[i]] = a
				i += 1
			end

			set_ga_data_array.push(datahash)

			#datahash sample ->  { "pagePath": "/archives/69839", ... , "goal1Completions": "23", "id": 4, "clickCount": 0 },
		end
		
		return set_ga_data_array
	end

	# db data by url
	def set_article_data(hostname, uri, startdate, enddate) 
		url = 'https://' + hostname + uri
		article = Article.find_by(url: url)
		start_date = startdate.to_date.beginning_of_day 
		end_date = enddate.to_date.end_of_day
		
		articleArr = Array.new

		if article
			id = article.id
			clickCount = article.clicks.where(:created_at => start_date..end_date).count
		else
			id = 0
			clickCount = 0
		end

		articleArr = [id, clickCount]

		return articleArr

	end

	# demographic data
	def get_demo(startdate, enddate)
		
		date_range = @analytics::DateRange.new(start_date: '2020-05-21', end_date: '2020-05-21')
		metric = @analytics::Metric.new(expression: 'ga:users')

		dimensions = ['ga:userAgeBracket', 'ga:userGender']
		dimension_type = Array.new
		dimensions.each do |d|
			dimension  = @analytics::Dimension.new
			dimension.name = d
			dimension_type.push(dimension)
		end

		request = @analytics::GetReportsRequest.new(
  			report_requests: [@analytics::ReportRequest.new(
    			view_id: @view_id, 
    			metrics: [metric],
    			dimensions: dimension_type,
    			date_ranges: [date_range],
  			)]
		)
		response = @client.batch_get_reports(request)

		data_from_google = response.reports.first.data.rows


		key_array = ['userAgeBracket', 'userGender', 'users']

		set_demo_array = Array.new

		datahash = {}
		maledata = Array.new
		femaledata = Array.new
		i = 0

		data_from_google.each_with_index do |r, index|

			if r.dimensions.second == 'male' 
				arr = [r.dimensions.first, r.metrics.first.values.first]
				maledata.push(arr)
			else
				arr = [r.dimensions.first, r.metrics.first.values.first]
				femaledata.push(arr)
			end

		end

		# formatting data for stacked bar chart
		malehash = {}
		malehash['name'] = 'Male'
		malehash['data'] = maledata
		malehash['stack'] = 'stack 1'

		femalehash = {}
		femalehash['name'] = 'female'
		femalehash['data'] = femaledata
		femalehash['stack'] = 'stack 2'

		set_demo_array.push(malehash)
		set_demo_array.push(femalehash)

		puts 'finish'

		return set_demo_array
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
