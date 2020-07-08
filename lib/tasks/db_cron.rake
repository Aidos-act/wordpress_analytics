namespace :db_cron do
  desc "TODO"
  task save_ga_api: :environment do

  	require "#{Rails.root}/lib/get_analytics.rb"

  	test = Domain.all
  	puts test.inspect

  	# test.each do |t|
  	# 	puts t.inspect
  	# end
  	
  end

end
