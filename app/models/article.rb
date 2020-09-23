class Article < ApplicationRecord
	belongs_to :domain
	has_many :ga_apis, dependent: :destroy
	has_many :goal_achievements, dependent: :destroy
	has_many :clicks, dependent: :destroy
	has_many :scrolls, dependent: :destroy
end

