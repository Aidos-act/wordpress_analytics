class Api::V1::ScrollDurationsController < ApplicationController
  def index
  	@scroll_durations = Scroll_duration.all
  end
end
