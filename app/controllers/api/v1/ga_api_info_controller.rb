require "#{Rails.root}/lib/get_analytics.rb"

class Api::V1::GaApiInfoController < ApplicationController
  # caches_action :index, :getTotalGaInfo, :getDemographic, expires_in: 5.hour

  def index
  	get_analytics_data = GetAnalytics.new

    articleDates = params[:startdate] + '~' + params[:enddate] + 'article'

    # caching 
    @data = Rails.cache.fetch(articleDates, expires_in: 10.hour) do
      @data = get_analytics_data.get_data(params[:startdate], params[:enddate])
    end



  end

  def getTotalGaInfo
    get_total = GetAnalytics.new

    totalDates = params[:startdate] + '~' + params[:enddate] + params[:hostname] + 'total'

    # caching 
    @totaldata = Rails.cache.fetch(totalDates, expires_in: 10.hour) do
      @totaldata = get_total.get_total_ga_info(params[:startdate], params[:enddate], params[:hostname])
    end
    
  end

  def getDemographic
    demo = GetAnalytics.new
    @demodata = demo.get_demo(params[:startdate], params[:enddate])
  end 

  def show
  	# article = Article.find(params[:id]) 이걸로 url갖고와서 그 url을 비지니스로직메소드에 담아 보냄. 비지니스로직에서 그걸로 처리한 후에 데이터 갖고 오고 그걸 골뱅이로 보냄.
  end
end