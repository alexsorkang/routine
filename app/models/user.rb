class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_many :routines, :class_name => "Routine"
  # has_one :current_routine, :class_name => "Routine"
  # , -> where{:id => user.current_routine_id} 
  # , :foreign_key => "current_routine_id"
  validates_uniqueness_of :username
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
