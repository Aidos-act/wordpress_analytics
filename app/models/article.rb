class Article < ApplicationRecord
	belongs_to :domain
	has_many :ga_apis, foreign_key: :ga_api_id, dependent: :destroy
	has_many :goal_achievements, foreign_key: :goal_achievement_id, dependent: :destroy
	has_many :clicks, dependent: :destroy
	has_many :scrolls, dependent: :destroy
end

