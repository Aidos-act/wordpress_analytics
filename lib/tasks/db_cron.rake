namespace :db_cron do
  desc "get data from google analytics and save into database"
  task save_ga_api: :environment do

  	require "#{Rails.root}/lib/get_analytics.rb"
  	require 'date'

    puts 'whenever start'

  	ga = GetAnalytics.new
  	yesterday = Date.yesterday.strftime("%Y-%m-%d")
    
    
  	article_key = Article.column_names
  	# remove id in array
  	article_key.shift

  	ga_key = GaApi.column_names
  	# remove id in array 
  	ga_key.shift

	  domains = Domain.all

#ddddddddddddddddd    
    
	  # article table
  	domains.each do |d|

  		view_id = (d.view_id).to_s
  		article_data = ga.get_article_data(yesterday, view_id, d.id, article_key)

      if article_data

        # insert new article data
        article_data.each do |article|
          Article.find_or_create_by(article_url: article['article_url']) do |new_article|
            new_article.domain_id = d.id
            new_article.article_title = article['article_title']
            new_article.max_position = article['max_position']
          end
        end

        # update article tabe if url is still same but title is changed
        article_data.each do |article|
          a = Article.find_by(article_url: article['article_url'])
          if a.article_title != article['article_title']
            a.update(domain_id: d.id, article_title: article['article_title'])
          end 
        end

      end

      # # update max_position if max_position is not the highest one
      # max_position_array = ga.get_max_position(yesterday, view_id)

      # articles = Article.select(:article_url, :max_position)

      # articles.each do |article|
      #   total_events = 0
      #   max_position = 1
      #   mobile_device_info = ''
      #   if max_position_array != nil
      #     max_arr = max_position_array.select{|max| max['article_url'] == article.article_url}
      #     if !max_arr.empty?
      #       max_arr.each do |a|
      #         if a['total_events'] > total_events

      #           total_events = a['total_events']
      #           mobile_device_info = a['mobileDeviceInfo']
      #           max_position = a['max_position']

      #         elsif  a['total_events'] == total_events && a['mobileDeviceInfo'] == 'Apple iPhone'

      #           if mobile_device_info == 'Apple iPhone' && a['max_position'] > max_position
      #             max_position = a['max_position']
      #           elsif mobile_device_info != 'Apple iPhone'
      #             mobile_device_info = a['mobileDeviceInfo']
      #             max_position = a['max_position']
      #           end

      #         end
              
      #       end
      #     end

      #     if article.max_position != max_position
      #       p article.article_url
      #       p article.max_position
      #       p max_position
      #       puts '*****************'
      #       # a.update(max_position: max_position)
      #     end
      #   end
      # end

  	end

  	# ga_api table
  	domains.each do |d|
  		view_id = (d.view_id).to_s
  		
  		ga_data = ga.get_ga_data(yesterday, view_id, ga_key)

      # if article_id and datehour is already exist, update the data(index added in schema). if not, insert data.
		  if ga_data
		  	GaApi.upsert_all(ga_data)
  		end
  		
  	end


    #click table
    domains.each do |d|
      view_id = (d.view_id).to_s
      click_data = ga.get_click_data(yesterday, view_id)

      if click_data
        Click.insert_all(click_data)
      end

    end

    # scroll table
    domains.each do |d|
      view_id = (d.view_id).to_s
      scroll_data = ga.get_scroll_data(yesterday, view_id)

      if scroll_data
        Scroll.insert_all(scroll_data)
      end

    end

#ddddddddddddddddd

    puts 'whenever end'


    # .where(clicks: {date_hour: Date.yesterday.beginning_of_day..Date.yesterday.end_of_day})
    # Article.left_joins(:ga_apis, :clicks).where(domain_id: 1).pluck("SUM(ga_apis.bounce) as bounce", "COUNT(clicks.article_id) as count")

  end

end
