class StudentsController < ApplicationController

	before_action :admin_user?, only: [ :new, :create, :destroy, :sendinvite ]
	before_action :set_student, only: [ :show, :edit, :update, :destroy, :sendinvite, :payments ]
  before_action :correct_user, only: [ :show, :edit, :update,  ]

	def show
		@payments = @student.payments.order("created_at DESC").page(1)
		@studentuser = User.find(@student.user_id) if @student.user_id
		@subscriptions = @student.subscriptions
	end

	def new
		@student = Student.new()
	end

	def create
		@student = Student.new(student_params)
		if @student.save
			if params[:send_invite_email] == "1"
				@student.send_invite_email
			end
			flash[:success] = "Student created."
			redirect_to admin_students_path
		else
			render "new"
		end
	rescue Stripe::StripeError => e
		flash[:error] = e.message
		redirect_to new_user_path
	end

	def edit
	end

	def update
		if @student.update_attributes(student_params)
			if params[:send_invite_email] == "1"
				@student.send_invite_email
			end
			flash[:success] = "Student info updated."
			redirect_to student_path(@student)
		else
			render "edit"
		end
	rescue Stripe::StripeError => e
		flash[:error] = e.message
		redirect_to new_user_path
	end

	def destroy
		@student.destroy
	end

	def sendinvite
		@student.send_invite_email
	end

	def payments
		@payments = @student.payments.order("created_at DESC").page(params[:page])
	end

	private

		def student_params
			params.require(:student).permit(
				:name,
				:email,
				:phone
			)
		end

		def set_student
			@student = Student.find(params[:id])
		end

		def correct_user
			unless current_user.is_admin? || current_user?( Student.find(params[:id]).user )
				redirect_to root_path, notice: "You do not have access to that page."
			end
		end
end
