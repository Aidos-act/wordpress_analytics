class Api::V1::ClicksController < ApplicationController
	skip_before_action :verify_authenticity_token
  before_action :find_ad
	# GET /clicks  
	# GET /clicks.json
  def index
      clicks = @article.clicks.all
      render json:clicks
  end

  def new
    @click = Click.new
    @click.click_x = params[:click_x]
    @click.click_y = params[:click_y]
    @click.btn_url = params[:btn_url]
    @click.btn_text = params[:btn_text]
    @click.view_ip = params[:view_ip]
    @click.article_id = params[:article_id]
    @click.save
  end

  private
    def find_ad
      @article = Article.find(params[:article_id])  
    end  

end
