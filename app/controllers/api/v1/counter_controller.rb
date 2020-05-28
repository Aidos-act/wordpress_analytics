class Api::V1::CounterController < ApplicationController
  before_action :find_ad

  def groupbyurl
    
    geturl = @article.clicks.select('btn_url, COUNT(ID) AS url_count').group(:btn_url)

    render json:geturl
  end

  def groupbytext

    gettext = @article.clicks.select('btn_text, COUNT(ID) AS text_count').group(:btn_text)

    render json:gettext
  end

  def countclick

  articles = Article.find_by_sql('SELECT count(ID) AS count_click FROM clicks where clicks.article_id = '+params[:article_id])
	@article = articles[0]

	render json:@article
  end

  def scrollcalculate

  scrolls = []
  tablename = "scrollpercent"
  maxscroll = @article.maxpos/744
  loopcount = 100/maxscroll
  total = @article.scrolls.count

    for i in 0..maxscroll do
      percent = ((@article.scrolls.where('scroll_pos >='+(i*loopcount).to_s+'').count)*100)/total
      scrolls[i] = percent
    end

  render json:scrolls

  end

  def durationcalculate

  maxdur = @article.scrolls.maximum(:scroll_dur)
  halfmax = maxdur/2
  getdur = @article.scrolls.where('scroll_pos <= 100').select('scroll_pos, SUM(scroll_dur) AS sum_dur').group(:scroll_pos)

  render json:getdur

  end

  def totalduration
    totaldur = @article.scrolls.sum(:scroll_dur)

    render json:totaldur
  end

  def ipcount

    getip = @article.clicks.select('view_ip, MAX(ID) AS ip_count').group(:view_ip)
    render json:getip
  end

  private
    def find_ad
      @article = Article.find(params[:article_id])  
    end

end