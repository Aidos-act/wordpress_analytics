class Article < ApplicationRecord
	has_many :clicks, dependent: :destroy
	has_many :scrolls, dependent: :destroy
	has_many :scroll_durations, dependent: :destroy
end

