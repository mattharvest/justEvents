class MicropostsController < ApplicationController
	before_filter :authenticate, :only => [:create, :destroy]
	before_filter :authorized_user, :only => :destroy
	
	def index
	end
	
	def create
		@micropost = current_user.microposts.build(params[:micropost])
		if @micropost.save
			flash[:success] = "Micropost created"
			redirect_to root_path
		else
			@feed_items=[]
			render 'pages/home'
		end
	end
	
	def destroy
		if @micropost.destroy
			flash[:notice] = "Micropost destroyed"
			redirect_back_or root_path
		else
			flash[:notice] = "Micropost not destroyed"
			redirect_to root_path
		end
	end
	
	private
		def authorized_user
			@microposts = current_user.microposts.find_by_id(params[:id])
			redirect_to root_path if @micropost.nil?
		end
end