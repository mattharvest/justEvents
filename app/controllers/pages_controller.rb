require 'csv'
class PagesController < ApplicationController

	def home
		@title="Home"
		if signed_in?
			@micropost = Micropost.new
			@feed_items = current_user.feed
		end
	end
	
	def reset_password
		@user=User.new
		@title="Reset password"
	end
	
	def cases
		@title="Casefiles"
		@casefiles = Casefile.find(:all)
	end
	
	def fulldisposition
		@title="Full Disposition"
		@micropost = Micropost.new
	end
	
	def reports
		@title="Reports"
		if signed_in?
			@posts=Micropost.find(:all)
			@unit_posts = Micropost.where("unit=?", current_user.unit)
			@self_posts = Micropost.where("user_id=?", current_user.id)
		end
	end
	
	def todos
		@title="Todos"
		@todos=[] #default
		if signed_in?
			@todoitem = Todoitem.new
			@todos = Todoitem.find(:all)
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
		csv_string = CSV.generate do |c|
		scope=params[:scope]	

		if scope.eql?("unit")
			@posts = Micropost.where("unit=?", params[:targetunit])
		elsif scope=="basic"
			@posts = Micropost.find(:all)	
		elsif scope=="date"
			#expecting 'start' and 'end' in yyyy-mm-dd format
			startdate = Date.strptime(params[:start], "%Y-%m-%d")
			enddate = Date.strptime(params[:end], "%Y-%m-%d")
			@posts = Micropost.find(:all, :conditions => ["event_date > ? AND event_date < ?", startdate, enddate])
		elsif scope=="dateunit"
			startdate = Date.strptime(params[:start], "%Y-%m-%d")
			enddate = Date.strptime(params[:end], "%Y-%m-%d")
			@posts = Micropost.all(:conditions => {
				:event_date => startdate..enddate, :unit=> params[:targetunit]})
		end
		
			c << ["event_date", "user", "user.email", "user.unit", "defendant", "dob", "adf", "category", "content", "created_at"]
			@posts.each do |post|
				c << [post.event_date.to_s, post.user.name, post.user.email, post.user.unit, post.defendant, post.dob, post.adf, post.category, post.content, post.created_at.to_s]
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
