class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_many :routines
  validates_uniqueness_of :username
  has_one :current_routine, :class_name => "Routine"
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
