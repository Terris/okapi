class UsersController < ApplicationController

	before_action :admin_user?, only: [ :destroy ]
	before_action :already_signed_in?, only: [ :new, :create ]
	before_action :correct_user, only: [ :show, :edit, :update, :payments  ]
	before_action :has_invite_token?, only: [ :new ]
	before_action :set_user, only: [:show, :edit, :update, :destroy, :activate, :deactivate ]

	def show
		if current_user == @user && admin_user?
			redirect_to edit_user_path(current_user)
		else
			@student = @user.student
		end
	end

	def new
		@user = User.new(:email => @newstudent.email)
	end

	def create
		@user = User.new(user_params)
		@newstudent = Student.where("email = ?", params[:user][:email]).first
		if @user.save
			sign_in @user
			redirect_to root_path
		else
			render 'new', it: @newstudent.invite_token
		end
	end

	def edit
	end

	def update
		if @user.update_attributes(user_params)
			flash[:success] = "Profile updated!"
			redirect_to root_path
		else
			render 'edit'
		end
	end

	def deactivate
		@user.deactivate
		flash[:success] = "User account deactivated."
	end

	def activate
		@user.activate
		flash[:success] = "User account activated."
	end

	private

		def user_params
			params.require(:user).permit(
				:name,
				:email,
				:password,
				:password_confirmation
			)
		end

		def already_signed_in?
			if signed_in?
				redirect_to root_path
			end
		end

		def correct_user
			unless current_user.is_admin? || current_user?( User.find(params[:id]) )
				redirect_to root_path, notice: "You do not have access to that page."
			end
		end

		def has_invite_token?
			@newstudent = Student.where( "invite_token = ?", params[:it] ).first
			redirect_to(root_path) unless !@newstudent.nil? && params[:it]
		end

		def set_user
			@user = User.find(params[:id])
		end
end
