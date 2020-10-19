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

  startdate =  params[:startdate].to_date.beginning_of_day
  enddate = params[:enddate].to_date.end_of_day

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
  
  total = @article.scrolls.where(date: startdate..enddate).count # add date
  
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
  startdate =  params[:startdate].to_date.beginning_of_day
  enddate = params[:enddate].to_date.end_of_day
  
  getdur = @article.scrolls.where(date: startdate..enddate).where('scroll_position <= 100').order('scroll_position asc').select('scroll_position, SUM(scroll_duration) AS sum_dur, SUM(access_count) AS access_count').group(:scroll_position)

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

  def maxduration

    startdate =  params[:startdate].to_date.beginning_of_day
    enddate = params[:enddate].to_date.end_of_day

    max = 0
    getdur = @article.scrolls.where(date: startdate..enddate).where('scroll_position <= 100').select('scroll_position, SUM(scroll_duration) AS sum_dur').group(:scroll_position)
    for i in 0..getdur.length-1 do
      if max < getdur[i].sum_dur then
        max = getdur[i].sum_dur
      end
    end
    render json:max

  end

  def durationpercentages

    startdate =  params[:startdate].to_date.beginning_of_day
    enddate = params[:enddate].to_date.end_of_day

    durations = []
    max = 0
    getdur = @article.scrolls.where(date: startdate..enddate).where('scroll_position <= 100').select('scroll_position, SUM(scroll_duration) AS sum_dur').group(:scroll_position)
    for i in 0..getdur.length-1 do
      if max < getdur[i].sum_dur then
        max = getdur[i].sum_dur
      end
    end
    
    m = max/60
    h = m/60
    s = max%60
    minute = m%60

    # durations[0] = ((max/3600).to_i).to_s + '時' + Time.at(max).strftime("%M") + '分' + Time.at(max).strftime("%S") + '秒'
    # durations[1] = ((max*0.8/3600).to_i).to_s + '時' + Time.at(max*0.8).strftime("%M") + '分' + Time.at(max*0.8).strftime("%S") + '秒'
    # durations[2] = ((max*0.6/3600).to_i).to_s + '時' + Time.at(max*0.6).strftime("%M") + '分' + Time.at(max*0.6).strftime("%S") + '秒'
    # durations[3] = ((max*0.4/3600).to_i).to_s + '時' + Time.at(max*0.4).strftime("%M") + '分' + Time.at(max*0.4).strftime("%S") + '秒'
    # durations[4] = ((max*0.2/3600).to_i).to_s + '時' + Time.at(max*0.2).strftime("%M") + '分' + Time.at(max*0.2).strftime("%S") + '秒'
    # durations[5] = '0時' + Time.at(0).strftime("%M") + '分' + Time.at(0).strftime("%S") + '秒'

    durations[0] = '15秒'
    durations[1] = '12秒'
    durations[2] = '9秒'
    durations[3] = '6秒'
    durations[4] = '3秒'
    durations[5] = '0秒'


    render json:durations
    
  end

  def ipcount

    getip = @article.clicks.select('view_ip, MAX(ID) AS ip_count').group(:view_ip)
    render json:getip
    
  end

  def scrollpcalculate
    
    startdate =  params[:startdate].to_date.beginning_of_day
    enddate = params[:enddate].to_date.end_of_day
    total_access = 0
    scrolls = []
    # access_counts = @article.scrolls.where(date: startdate..enddate).order('scroll_position asc').select(:scroll_position, :access_count)
    
    access_counts = @article.scrolls.where(date: startdate..enddate)
                                    .order('scroll_position asc')
                                    .group(:scroll_position)
                                    .select(:scroll_position, "SUM(access_count) as access_count")

    
    if access_counts.first.scroll_position == 1
      total_access = access_counts.first.access_count
    end

    for i in 1..100 do
      count = access_counts.select{|pos| pos.scroll_position == i}

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