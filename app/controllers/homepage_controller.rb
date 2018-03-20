class HomepageController < ApplicationController
  def index
  	if signed_in? && current_user
  		redirect_to student_path(current_user_student)
  	end
  end
end
