require 'csv'
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
		if signed_in?
			@posts=Micropost.find(:all)
			@unit_posts = Micropost.where("unit=?", current_user.unit)
			@self_posts = Micropost.where("user_id=?", current_user.id)
		end
	end
	
	def calls
		@title="Calls"
		if signed_in?
			@micropost = Micropost.new
			@feed_items = current_user.feed
		end
	end
	
	def export_to_csv
		#NEEDS TO BE EXPANDED TO TAKE DATE RANGE AS PARAMETERS
		all_posts
		csv_string = CSV.generate do |c|
			c << ["user", "casenumber", "content", "event_date"]
			@posts.each do |post|
				c << [post.user.name, post.casenumber, post.content, post.event_date.to_s]
			end
		end
		
		send_data csv_string,
			:type => 'text/csv; charset=iso8859-1; header=present',
			:disposition => 'attachment; filename=posts.csv'
	end
	

	def help
		@title = "Help"
	end
  
	def users
		@title = "Users"
	end
	
	def posts
		@title = "Posts"
		if signed_in?
			@posts=Micropost.find(:all)
			@unit_posts = Micropost.where("unit=?", current_user.unit)
			@self_posts = Micropost.where("user_id=?", current_user.id)
		end
	end

end
