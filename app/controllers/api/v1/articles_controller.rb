class Api::V1::ArticlesController < ApplicationController
	
	skip_before_action :verify_authenticity_token
	before_action :set_article, only: [:show]

	# GET /articles
	# GET /articles.json
	def index
	  @articles = Article.all
	end

	# GET /articles/1
	# GET /articles/1.json 
	def show
		# @article = Article.find_by(url: params[:path])
	end

	# GET /articles/new
	def new
      if Article.exists?(params[:id])
        @article = Article.find(params[:id])
        @article.article_title = params[:article_title]
        @article.article_url = params[:article_url]
        if params[:maxpos].to_i > @article.maxpos
          @article.maxpos = params[:maxpos]
        end
        @article.save
      else
        @article = Article.new
        @article.article_title = params[:article_title]
        @article.article_url = params[:article_url]
        @article.id = params[:id]
        @article.maxpos = params[:maxpos]
        @article.save
      end
	end

	private
	  # Use callbacks to share common setup or constraints between actions.
	  def set_article
	    @article = Article.find(params[:id])
	  end


end

