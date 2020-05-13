class Api::V1::ScrollsController < ApplicationController
	skip_before_action :verify_authenticity_token
  	before_action :find_ad
	# GET /scrolls  
	# GET /scrolls.json
	def index
	  @scrolls = Scroll.all
	end

    def new
      @scrolls = Maxpo.new
      @scrolls.scroll_max_pos = params[:scroll_max_pos]
      @scrolls.article_id = params[:article_id]
      @scrolls.save
    end

  private
    def find_ad
      @article = Article.find(params[:article_id])
    end

end
