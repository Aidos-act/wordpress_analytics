class Api::V1::ArticlesController < ApplicationController
	
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
	  @article = Article.new
      @article.title = params[:title]
      @article.url = params[:url]
      @article.id = params[:id]
      @article.save
	end

	# GET /articles/1/edit
	def edit
	end

	# POST /articles
	# POST /articles.json
	def create
	  @article = Article.new(article_params)

	  respond_to do |format|
	    if @article.save
	      format.html { redirect_to @article, notice: 'Article was successfully created.' }
	      format.json { render :show, status: :created, location: @article }
	    else
	      format.html { render :new } 
	      format.json { render json: @article.errors, status: :unprocessable_entity }
	    end
	  end
	end

	# PATCH/PUT /articles/1
	# PATCH/PUT /articles/1.json
	def update
	  respond_to do |format|
	    if @article.update(article_params)
	      format.html { redirect_to @article, notice: 'Article was successfully updated.' }
	      format.json { render :show, status: :ok, location: @article }
	    else
	      format.html { render :edit }
	      format.json { render json: @article.errors, status: :unprocessable_entity }
	    end
	  end
	end

	# DELETE /articles/1
	# DELETE /articles/1.json
	def destroy
	  @article.destroy
	end

	private
	  # Use callbacks to share common setup or constraints between actions.
	  def set_article
	    @article = Article.find(params[:id])
	  end
	  # Only allow a list of trusted parameters through.
	  def article_params
	    params.require(:article).permit(:id, :title, :url, :created_at, :path, :startdate, :enddate)
	  end

end

