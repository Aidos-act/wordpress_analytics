require 'google/apis/analyticsreporting_v4'

class GetAnalytics

	VIEW_ID = "214644944"

	def initialize() 
		@view_id = VIEW_ID
		@analytics = Google::Apis::AnalyticsreportingV4
		auth
	end

	def get_data(startdate, enddate)
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
		dimension = @analytics::Dimension.new(name: 'ga:pagePath')

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
    			metrics: metric_type, 
    			dimension_filter_clauses: [dimension_filters],
    			dimensions: [dimension], 
    			date_ranges: [date_range]
  			)]
		)
		response = @client.batch_get_reports(request)
		data_from_google = response.reports.first.data.rows

		datahash = {}

		data_from_google.each do |r|
			key = r.dimensions.first
			datahash[key.to_sym] = r.metrics.first.values
		end

		return datahash
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
