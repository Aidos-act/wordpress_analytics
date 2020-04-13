class Api::V1::ClicksController < ApplicationController

	# GET /clicks  
	# GET /clicks.json
	def index
	  @clicks = Click.all
	end

end
