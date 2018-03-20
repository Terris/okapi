class RostersController < ApplicationController
	
	before_action :admin_user?
	before_action :set_roster, only: [ :show, :edit, :update, :destroy ]

	def show
		@enrolled_students = @roster.students
		@students = Student.visible.where.not(id: @enrolled_students)
	end

	def new
		@roster = Roster.new
	end

	def create
		@roster = Roster.new(roster_params)
		if @roster.save
			flash[:success] = "Roster created."
			redirect_to admin_path
		else
			render "new"
		end
	end

	def edit
	end

	def update
		if @roster.save
			flash[:success] = "Roster updated."
			redirect_to admin_path
		else
			render "edit"
		end
	end

	def destroy
		@roster.destroy
	end

	def enrollment_create
		@roster = Roster.find(params[:id])
		@student = Student.find_by_id(params[:sid])
		Enrollment.create(:roster_id => params[:id], :student_id => params[:sid])
	end

	def enrollment_remove
		@roster = Roster.find(params[:id])
		@student = Student.find_by_id(params[:sid])
		Enrollment.where("roster_id = ? AND student_id = ?", params[:id], params[:sid]).first.destroy
	end

	private

		def roster_params
			params.require(:roster).permit(
				:class_name,
				:start_date,
				:end_date,
				:plan_id
			)
		end

		def set_roster
			@roster = Roster.find(params[:id])
		end


end
