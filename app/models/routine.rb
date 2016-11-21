class Routine < ActiveRecord::Base
	# belongs_to :user
  belongs_to :users
  # has_many :currently_on, :class_name => 'Users'
  # has_one :currently_using, :class_name => "User", :foreign_key => "currently_using_id"
	validates :name, presence: true
	validates :difficulty, presence: true
end
