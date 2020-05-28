class Api::V1::ClicksController < ApplicationController
	skip_before_action :verify_authenticity_token
  before_action :find_ad, only: [:new]
	# GET /clicks  
	# GET /clicks.json
	def index
    start_date = params[:startdate].to_date.beginning_of_day
    end_date = params[:enddate].to_date.end_of_day
    puts 'oh my god'
	  @clicks = Click.where(:created_at => start_date..end_date)

	end

  def show
    # @article = Article.find_by(url: params[:path])
  end

  def new
    @click = Click.new
    @click.click_x = params[:click_x]
    @click.click_y = params[:click_y]
    @click.btn_id = params[:btn_id]
    @click.view_ip = params[:view_ip]
    @click.article_id = params[:article_id]
    if(@click.click_x != 0 && @click.click_y != 0)
      @click.save
    end
  end

  private
    def find_ad
      @article = Article.find(params[:article_id])  
    end    

end
