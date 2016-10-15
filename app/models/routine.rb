class Routine < ActiveRecord::Base
	belongs_to :user
	validates :name, presence: true
	validates :difficulty, presence: true
end
