class GoalAchievement < ApplicationRecord
	belongs_to :article
	belongs_to :goal
end
