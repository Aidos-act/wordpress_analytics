class Api::V1::ClicksController < ApplicationController
	skip_before_action :verify_authenticity_token
  	before_action :find_ad
	# GET /clicks  
	# GET /clicks.json
	def index
	  @clicks = Click.all
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
