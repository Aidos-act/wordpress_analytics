require "#{Rails.root}/lib/get_analytics.rb"

class Api::V1::GaApiInfoController < ApplicationController
  def index
  	get_analytics_data = GetAnalytics.new
    @data = get_analytics_data.get_data(params[:startdate], params[:enddate])
  end

  def getTotalGaInfo
    get_total = GetAnalytics.new
    @totaldata = get_total.get_total_ga_info(params[:startdate], params[:enddate])
    puts 'im in total ga info'
  end

  def getDemographic
    demo = GetAnalytics.new
    @demodata = demo.get_demo(params[:startdate], params[:enddate])
  end 

  def show
  	# article = Article.find(params[:id]) 이걸로 url갖고와서 그 url을 비지니스로직메소드에 담아 보냄. 비지니스로직에서 그걸로 처리한 후에 데이터 갖고 오고 그걸 골뱅이로 보냄.
  end
end