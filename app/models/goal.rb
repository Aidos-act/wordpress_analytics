class Goal < ApplicationRecord
	belongs_to :domain
	has_many :goal_achievements, foreign_key: :goal_achievement_id, dependent: :destroy
end
