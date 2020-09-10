# == Schema Information
#
# Table name: domains
#
#  id           :bigint           not null, primary key
#  domain_name  :string           not null
#  view_id      :integer   
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Domain < ApplicationRecord
	has_many :articles, foreign_key: :article_id, dependent: :destroy
	has_many :goals, foreign_key: :goal_id, dependent: :destroy
end
