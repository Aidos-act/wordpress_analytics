class Api::V1::GaApisController < ApplicationController
  require "#{Rails.root}/lib/get_analytics.rb"
  def currentTotal
    
    domain_id = set_domain(params[:hostname])

    startdate =  params[:startdate].to_date.beginning_of_day
    enddate = params[:enddate].to_date.end_of_day

    key_array = ['page_view', 'user', 'new_user', 'bounce', 'session', 'avg_time_on_page', 'mcv']

    @currentTotal = get_total_data_from_db(domain_id, startdate, enddate, key_array)
    

    render :formats => :json, :handlers => :jbuilder

  end

  def compareTotal

    domain_id = set_domain(params[:hostname])

    compare_dates = set_compare_dates(params[:startdate], params[:enddate])

    key_array = ['page_view', 'user', 'new_user', 'bounce', 'session', 'avg_time_on_page', 'mcv']


    @compareTotal = get_total_data_from_db(domain_id, compare_dates[0], compare_dates[1], key_array)

    render :formats => :json, :handlers => :jbuilder

  end

  def currentLineChart

    domain_id = set_domain(params[:hostname])

    startdate =  params[:startdate].to_date.beginning_of_day
    enddate = params[:enddate].to_date.end_of_day

    @currentLineChart = get_chart_data_from_db(domain_id, startdate, enddate)
    
    render :formats => :json, :handlers => :jbuilder

  end

  def compareLineChart

    domain_id = set_domain(params[:hostname])

    compare_dates = set_compare_dates(params[:startdate], params[:enddate])

    @compareLineChart = get_chart_data_from_db(domain_id, compare_dates[0], compare_dates[1])

    render :formats => :json, :handlers => :jbuilder

  end

  def articleData
    domain_id = set_domain(params[:hostname])

    startdate =  params[:startdate].to_date.beginning_of_day
    enddate = params[:enddate].to_date.end_of_day

    @articleData = get_article_data_from_db(domain_id, startdate, enddate)

    render :formats => :json, :handlers => :jbuilder

  end

  def articleAvg
    domain_id = set_domain(params[:hostname])

    startdate =  params[:startdate].to_date.beginning_of_day
    enddate = params[:enddate].to_date.end_of_day

    @articleAvg = get_article_avg_from_db(domain_id, startdate, enddate)
    
    render :formats => :json, :handlers => :jbuilder

  end

  def goalData
    domain_id = set_domain(params[:hostname])

    startdate =  params[:startdate]
    enddate = params[:enddate]

    get_analytics_data = GetAnalytics.new

    @goalData = get_analytics_data.get_goal_data(startdate, enddate)

    render :formats => :json, :handlers => :jbuilder

  end

  def goalDataByArticle
    domain_id = set_domain(params[:hostname])

    startdate =  params[:startdate]
    enddate = params[:enddate]

    get_analytics_data = GetAnalytics.new

    @goalDataByArticle = get_analytics_data.get_goal_data_by_article(startdate, enddate)

    render :formats => :json, :handlers => :jbuilder
    
  end

  private

    def set_domain(hostname)

      # set up domain id
      if hostname == 'total'
        domain_id = Domain.pluck(:id)
      else
        domain_id = Domain.where(domain_name: hostname).pluck(:id)
      end

      return domain_id

    end

    def set_compare_dates(sdate, edate)

      startdate = sdate.to_date
      enddate = edate.to_date

      # get compare dates
      if startdate == enddate then
        s_date = startdate - 1.day
        e_date = enddate - 1.day
      else
        diff = (enddate - startdate).to_i + 1
        s_date = startdate - diff.days
        e_date = enddate - diff.days
      end 

      compare_startdate = s_date.beginning_of_day
      compare_enddate = e_date.end_of_day

      compare_dates = [compare_startdate, compare_enddate]

      return compare_dates

    end

    def get_total_data_from_db(domain_id, startdate, enddate, key_array)

      ga_data_hash ={}

      ga_total_data = Article.joins(:ga_apis)
                           .where(ga_apis: {date_hour: startdate..enddate})
                           .where(domain_id: domain_id)
                           .pluck("SUM(ga_apis.page_view) as page_view",
                                  "SUM(ga_apis.user) as user",
                                  "SUM(ga_apis.new_user) as new_user",
                                  "SUM(ga_apis.bounce) as bounce",
                                  "SUM(ga_apis.session) as session",
                                 )
                          
      # avg_time_on_page
      ga_total_avg_time = Article.joins(:ga_apis)
                                .where(ga_apis: {date_hour: startdate..enddate})
                                .where(domain_id: domain_id)
                                .where.not(ga_apis: {avg_time_on_page: 0})
                                .group(:id)
                                .pluck("COUNT(avg_time_on_page)", "SUM(avg_time_on_page)")

      avg_sum = 0
      article_num = ga_total_avg_time.size

      begin      
        ga_total_avg_time.each do |a|
          avg_division = a[1]/a[0]
          avg_sum += avg_division
        end

        avg_time_on_page = avg_sum/article_num
      rescue StandardError
        avg_time_on_page = nil
      end

      ga_total_data.first.push(avg_time_on_page)


      # click count 
      ga_total_mcv = Article.joins(:clicks).where(domain_id: domain_id).where(clicks: {date_hour: startdate..enddate}).count     

      ga_total_data.first.push(ga_total_mcv)



      ga_total_data.first.each_with_index do |g, index|
        ga_data_hash[key_array[index]] = g
      end


      return ga_data_hash

    end

    def get_chart_data_from_db(domain_id, startdate, enddate)
      
      # data for line chart. group by date_hour. pluck -> get data with array type
      ga_line_chart_data = Article.joins(:ga_apis)
                                  .where(ga_apis: {date_hour: startdate..enddate})
                                  .where(domain_id: domain_id)
                                  .group("ga_apis.date_hour")
                                  .order("ga_apis.date_hour asc")
                                  .pluck("ga_apis.date_hour",
                                         "SUM(ga_apis.page_view) as page_view",
                                         "SUM(ga_apis.user) as user",
                                         "SUM(ga_apis.new_user) as new_user",
                                         "SUM(ga_apis.bounce) as bounce",
                                         "SUM(ga_apis.session) as session")

      # get time_on_page grouped by time span. pluck -> get data with array type
      ga_line_chart_avg_time = Article.joins(:ga_apis)
                                      .where(ga_apis: {date_hour: startdate..enddate})
                                      .where(domain_id: domain_id)
                                      .where.not(ga_apis: {avg_time_on_page: 0})
                                      .group("ga_apis.date_hour")
                                      .order("ga_apis.date_hour asc")
                                      .pluck("ga_apis.date_hour", "COUNT(avg_time_on_page)", "SUM(avg_time_on_page)")

      # get click count grouped by time span. pluck -> get data with array type                             
      ga_line_chart_mcv = Article.joins(:clicks)
                                 .where(domain_id: domain_id)
                                 .where(clicks: {date_hour: startdate..enddate})
                                 .group("clicks.date_hour")
                                 .order("clicks.date_hour asc")
                                 .pluck("clicks.date_hour", "COUNT(clicks.id)")                                      

      # set time_on_page data and click count
      ga_line_chart_data.each do |a|
        
        begin
          ga_line_chart_avg_time.each do |avg|
            if a[0] == avg[0]
              avg_time = avg[2]/avg[1]
              a.push(avg_time)
            end
          end
        rescue StandardError
          a.push(nil)
        end

        begin
          ga_line_chart_mcv.each do |click|
            if a[0] == click[0]
              a.push(click[1])
            end
          end
        rescue StandardError
          a.push(nil)
        end

      end

      return ga_line_chart_data

    end

    def get_article_data_from_db(domain_id, startdate, enddate)

      # data for each article. it is dor ArticleDashboard.vue
      ga_article_data = Article.joins(:ga_apis, :domain)
                               .where(ga_apis: {date_hour: startdate..enddate})
                               .where(domain_id: domain_id)
                               .group(:id)
                               .order("sum(ga_apis.page_view) desc")
                               .pluck(:id,
                                      "domains.domain_name",
                                      :article_title,
                                      :article_url,
                                      "SUM(ga_apis.page_view) as page_view",
                                      "SUM(ga_apis.user) as user",
                                      "SUM(ga_apis.new_user) as new_user",
                                      "SUM(ga_apis.bounce) as bounce",
                                      "SUM(ga_apis.session) as session")                     

      ga_article_avg_time = Article.joins(:ga_apis)
                                  .where(ga_apis: {date_hour: startdate..enddate})
                                  .where(domain_id: domain_id)
                                  .where.not(ga_apis: {avg_time_on_page: 0})
                                  .group(:id)
                                  .pluck(:id, 
                                         "COUNT(avg_time_on_page)", 
                                         "SUM(avg_time_on_page)")

      ga_article_mcv = Article.joins(:clicks)
                                .where(domain_id: domain_id)
                                .where(clicks: {date_hour: startdate..enddate})
                                .group(:id)
                                .pluck(:id, "COUNT(clicks.id)")   
     
      ga_article_data.each do |a|
        avg_flag = 0  
        mcv_flag = 0

        ga_article_avg_time.each do |avg|
          if a[0] == avg[0]
            avg_time = avg[2]/avg[1]
            a.push(avg_time)
            avg_flag = 1
          end
        end

        if avg_flag == 0
          a.push(avg_flag)
        end


        ga_article_mcv.each do |click|
          if a[0] == click[0]
            a.push(click[1])
            mcv_flag = 1
          end
        end

        if mcv_flag == 0
          a.push(mcv_flag)
        end

      end

      return ga_article_data

    end # get_article_data_from_db end


    def get_article_avg_from_db(domain_id, startdate, enddate)

      ga_page_view = Article.joins(:ga_apis)
                            .where(ga_apis: {date_hour: startdate..enddate})
                            .where(domain_id: domain_id)
                            .group(:id)
                            .order("sum(ga_apis.page_view) desc")
                            .limit(10)
                            .pluck("SUM(ga_apis.page_view) as page_view")

      ga_mcv = Article.joins(:clicks)
                      .where(clicks: {date_hour: startdate..enddate})
                      .where(domain_id: domain_id)
                      .group(:id)
                      .order("count(clicks.id) desc")
                      .limit(10)
                      .pluck("COUNT(clicks.id)")


      ga_avg_time_sum = Article.joins(:ga_apis)
                               .where(ga_apis: {date_hour: startdate..enddate})
                               .where(domain_id: domain_id)
                               .where.not(ga_apis: {avg_time_on_page: 0})
                               .group(:id)
                               .order("SUM(ga_apis.page_view) desc")
                               .limit(10)
                               .pluck("COUNT(avg_time_on_page)", "SUM(avg_time_on_page)")
      ga_avg_time = []

      begin
        ga_avg_time_sum.each do |avg|
          avg_time = avg[1] / avg[0]
          ga_avg_time.push(avg_time)
        end 
      rescue StandardError
        ga_avg_time.push(0)
      end

      ga_bounce_avg = Article.joins(:ga_apis)
                             .where(ga_apis: {date_hour: startdate..enddate})
                             .where(domain_id: domain_id)
                             .where.not(ga_apis: {bounce: 0})
                             .group(:id)
                             .order("sum(ga_apis.page_view) desc")
                             .limit(10)
                             .pluck("sum(ga_apis.bounce) as bounce")                       

      begin
        ga_pv_avg = ga_page_view.sum(0) / ga_page_view.size
      rescue StandardError
        ga_pv_avg = 0
      end

      begin
        ga_mcv_avg = ga_mcv.sum(0) / ga_mcv.size
      rescue StandardError
        ga_mcv_avg = 0
      end

      begin
        ga_avg_time_avg = ga_avg_time.sum(0) / ga_avg_time.size
      rescue StandardError
        ga_avg_time_avg = 0
      end

      begin
        ga_bounce_avg = ga_bounce_avg.sum(0) / ga_bounce_avg.size
      rescue StandardError
        ga_bounce_avg = 0
      end


      ga_avg = {ga_pv_avg: ga_pv_avg, ga_mcv_avg: ga_mcv_avg, ga_avg_time_avg: ga_avg_time_avg, ga_bounce_avg: ga_bounce_avg}

      return ga_avg
    end # get_article_avg_from_db end

end
