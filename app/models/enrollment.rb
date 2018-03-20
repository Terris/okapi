class Enrollment < ActiveRecord::Base
  belongs_to :roster
  belongs_to :student
end
