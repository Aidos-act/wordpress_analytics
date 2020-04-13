class Api::V1::ScrollsController < ApplicationController

	# GET /scrolls  
	# GET /scrolls.json
	def index
	  @scrolls = Scroll.all
	end


end
