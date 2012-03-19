class UsersController < ApplicationController
	before_filter :authenticate, :only=> [:edit, :update, :index]
	before_filter :correct_user, :only => [:edit, :update]
	before_filter :admin_user, :only => :destroy
	
  def new
	@user = User.new
	@title = "Sign Up"
  end
	
	def destroy
		User.find(params[:id]).destroy
		flash[:success] = "User destroyed."
		redirect_to users_path
	end
  
	def create
		@user = User.new(params[:user])
		if @user.save
		sign_in @user
			flash[:success] = "Welcome to justEvents"
			redirect_to @user
		else
			@title = "Sign Up"
			render 'new'
		end
	end
	
	def index
		@title = "All users"
		@users = User.all
	end
  
	def show
		@user = User.find(params[:id])
		@title = @user.name
		@microposts = @user.microposts		
		@recent_posts = @user.microposts.find(:all, :limit => 7, :order => 'created_at DESC')
	end
	
	def edit
		@title = "Edit user"
	end
	
	def update
		@user = User.find(params[:id])
		if @user.update_attributes(params[:user])
			flash[:succcess] = "Profile updated."
			redirect_to @user
		else
			@title = "Edit User"
			render 'edit'
		end
	end
	
	private
		
		def correct_user
			@user = User.find(params[:id])
			redirect_to(root_path) unless current_user?(@user)
		end
		
		def admin_user
			redirect_to(root_path) unless current_user.admin?
		end
end
