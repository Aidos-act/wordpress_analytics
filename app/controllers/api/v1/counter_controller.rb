require 'date'

class Api::V1::CounterController < ApplicationController

  before_action :find_ad, except: :avgdurall

  def groupbyhour
    if startdate == enddate then
      hour = @article.clicks.select('hour(created_at), COUNT(ID) AS click_count').group('hour(created_at)').order('hour(created_at)' 'asc')
      render json:hour
    end
  end

  def groupbydate
    
    dates = @article.clicks.select('date(created_at), COUNT(ID) AS click_count').group('date(created_at)')
    result = dates.select('(SELECT url FROM articles where id = '+params[:article_id]+') AS url')
    render json:result

  end  

  def groupbyurl
    startdate =  params[:startdate].to_date.beginning_of_day
    enddate = params[:enddate].to_date.end_of_day

    geturl = @article.clicks.where(date_hour: startdate..enddate).select('button_url, COUNT(ID) AS url_count').group(:button_url)
    render json:geturl

  end

  def groupbytext
    startdate =  params[:startdate].to_date.beginning_of_day
    enddate = params[:enddate].to_date.end_of_day

    gettext = @article.clicks.where(date_hour: startdate..enddate).select('button_text, COUNT(ID) AS text_count').group(:button_text)
    
    render json:gettext

  end

  def countclick

  # articles = Article.find_by_sql('SELECT count(ID) AS count_click FROM clicks where click_x != 0 and clicks.article_id = '+params[:article_id])
  # @article = articles[0]

  startdate =  params[:startdate].to_date.beginning_of_day
  enddate = params[:enddate].to_date.end_of_day

  count_click = @article.clicks.where(date_hour: startdate..enddate).count

  render json:count_click
  
  end

  def scrollcalculate

  scrolls = []
  tablename = "scrollpercent"

  startdate = (DateTime.parse(params[:startdate]) + 1.day).to_date.beginning_of_day
  enddate = (DateTime.parse(params[:enddate]) + 1.day).to_date.end_of_day

  begin
    maxscroll = @article.max_position/744 
  rescue StandardError
    maxscroll = 1000/744
  end

  begin
    loopcount = 100/maxscroll
  rescue StandardError
    loopcount = 10
  end
  
  total = @article.scrolls.where(created_at: startdate..enddate).count # add date
  
  for i in 0..maxscroll do
    begin
      percent = ((@article.scrolls.where('scroll_position >='+(i*loopcount).to_s+'').count)*100)/total
    rescue StandardError => e
      puts e
      percent = 10
    end
    
    scrolls[i] = percent
  end

  render json:scrolls

  end

  def durationcalculate

  # maxdur = @article.scrolls.maximum(:scroll_duration)
  # halfmax = maxdur/2
  startdate = (DateTime.parse(params[:startdate]) + 1.day).to_date.beginning_of_day
  enddate = (DateTime.parse(params[:enddate]) + 1.day).to_date.end_of_day

  getdur = @article.scrolls.where(created_at: startdate..enddate).where('scroll_position <= 100').select('scroll_position, SUM(scroll_duration) AS sum_dur').group(:scroll_position)

  render json:getdur

  end

  def avgdurall

    avgdur = Article.select('(select AVG(scroll_duration) FROM SCROLLS) AS total_avg_dur' )

    render json:avgdur[0]

  end

  def avgdurarticle

    avgdur = @article.scrolls.average(:scroll_duration)
    render json:avgdur

  end

  def totalduration

    startdate = (DateTime.parse(params[:startdate]) + 1.day).to_date.beginning_of_day
    enddate = (DateTime.parse(params[:enddate]) + 1.day).to_date.end_of_day

    totaldur = @article.scrolls.where(created_at: startdate..enddate).sum(:scroll_duration)
    render json:totaldur

  end

  def ipcount

    getip = @article.clicks.select('view_ip, MAX(ID) AS ip_count').group(:view_ip)
    render json:getip
    
  end

  def scrollpcalculate
    
    startdate = (DateTime.parse(params[:startdate]) + 1.day).to_date.beginning_of_day
    enddate = (DateTime.parse(params[:enddate]) + 1.day).to_date.end_of_day
    total_access = 0
    scrolls = []
    access_counts = @article.scrolls.where(created_at: startdate..enddate).order('scroll_position asc').select(:scroll_position, :access_count)
    # access_counts = @article.scrolls.where(created_at: startdate..enddate).order('scroll_position asc').pluck(:scroll_position, :access_count)  
    
    if access_counts.first.scroll_position == 5
      total_access = access_counts.first.access_count
    end

    scroll_positions = [5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90,95,100]

    scroll_positions.each_with_index do |position, i|
      count = access_counts.select{|pos| pos.scroll_position == position}

      if !count.empty?
        float_count = count.first.access_count.to_f
        percent = ((float_count/total_access).round(2))*100
        scrolls.push(percent.to_i)
      elsif count.empty?
        scrolls.push(0)
      end

    end 

    render json:scrolls
  end  


  private
    def find_ad
      @article = Article.find(params[:article_id])  
    end

end