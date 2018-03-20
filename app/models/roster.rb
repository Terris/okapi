class Roster < ActiveRecord::Base
  
  has_many :enrollments, dependent: :destroy
  has_many :students, through: :enrollments

  validates_presence_of :class_name
  validates_presence_of :start_date

end
