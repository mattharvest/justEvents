class PagesController < ApplicationController
	def home
		@title="Home"
		if signed_in?
			@micropost = Micropost.new
			@feed_items = current_user.feed
		end
	end
	
	def reports
		@title="Reports"
		if signed_in?&&!current_user.admin?
			unit_posts
		elsif signed_in?
			all_posts
		else
			self_posts
		end
	end
	
	def all_posts
		@posts = Micropost.find(:all)
	end
	
	def unit_posts
		@posts = Micropost.where("unit=?", current_user.unit)
	end
	
	def self_posts
		@posts = Micropost.where("user_id=?", current_user.id)
		@feed_items = current_user.feed
	end

	def help
		@title = "Help"
	end
  
	def users
		@title = "Users"
	end
	
	def posts
		@title = "Posts"
		self_posts
	end

end
