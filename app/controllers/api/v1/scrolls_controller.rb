class Api::V1::ScrollsController < ApplicationController
  skip_before_action :verify_authenticity_token
    before_action :find_ad

  def index
    @scrolls = Scroll.all
  end

  def new
    @scroll = Scroll.new
    @scroll.scroll_pos = params[:scroll_pos]
    @scroll.scroll_dur = params[:scroll_dur]
    @scroll.article_id = params[:article_id]
    @scroll.save
  end

  private
    def find_ad
      @article = Article.find(params[:article_id])
    end

end
