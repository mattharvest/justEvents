require 'csv'

class PagesController < ApplicationController

	def home
		@title="Home"
		if signed_in?
			redirect_to current_user
		else
			redirect_to post_path
		end
	end
	
	def post
		@micropost = Micropost.new
		if signed_in?					
			if current_user.title=="CHIEF"
				@yesterdays_posts = Micropost.find_all_by_unit_and_created_at(current_user.unit, [24.hours.ago..0.seconds.ago])
			else 
				@yesterdays_posts = Micropost.find_all_by_unit_and_created_at_and_user_id(current_user.unit, [24.hours.ago..0.seconds.ago], current_user.id)
			end
		else
			@yesterdays_posts=[]
		end
	
	end
	
	def reset_password
		@user=User.new
		@title="Reset password"
	end
	
	def cases
		@title="Casefiles"
		#@casefiles = Casefile.find(:all)
		@casefiles = Casefile.paginate(:page=>params[:page], :per_page => 20).order('updated_at DESC')
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
	
	def custom_report
		@title = "Custom Search"
		@start=params[:start]
		@end=params[:end]
		@category=params[:micropost_category]
		if @microposts = Micropost.find_all_by_category_and_event_date(params[:micropost_category], [params[:start]..params[:end]])
		else
			flash[:microposterror] = "Search by category and date failed!"
		end
	end
	
	def last_week
		if !signed_in?
			return
		end
		
		unit=current_user.unit
		@posts = Micropost.find_all_by_unit_and_event_date(params[:unit], [Date.today-7..Date.today])
		csv_string = CSV.generate do |c|
			c << ["event_date", "user", "user.email", "user unit", "post unit", "defendant", "dob", "adf", "category", "content", "created_at", "jail", "probation", "community service", "judge", "lead charge", "convicted charges", "enhanced", "guidelines", "team leader"]
			@posts.each do |post|
				leader = User.new
				if !post.teamleader.blank? && !post.teamleader.nil?
					leader = User.find_by_id(post.teamleader)
				end
				if leader.nil?
					c << [post.event_date.to_s, post.user.name.to_s, post.user.email.to_s, post.user.unit.to_s, post.unit.to_s, post.defendant.to_s, post.dob.to_s, post.adf.to_s, post.category.to_s, post.content.to_s, post.created_at.to_s, post.jail.to_s, post.probation.to_s, post.communityservice.to_s, post.judge.to_s, post.leadcharge.to_s, post.convictedcharges.to_s, post.enhanced.to_s, post.guidelines.to_s, ""]
				else
					c << [post.event_date.to_s, post.user.name.to_s, post.user.email.to_s, post.user.unit.to_s, post.unit.to_s, post.defendant.to_s, post.dob.to_s, post.adf.to_s, post.category.to_s, post.content.to_s, post.created_at.to_s, post.jail.to_s, post.probation.to_s, post.communityservice.to_s, post.judge.to_s, post.leadcharge.to_s, post.convictedcharges.to_s, post.enhanced.to_s, post.guidelines.to_s, leader.name_comma]
				end
			end
		end
		
		send_data csv_string,
			:type => 'text/csv; charset=iso8859-1; header=present',
			:disposition => 'attachment; filename=this_weeks_posts.csv'
	
	end
	
	def export_to_csv
		csv_string = CSV.generate do |c|
		scope=params[:scope]	

		if scope.eql?("unit")
			@posts = Micropost.where("unit=?", params[:targetunit])
		elsif scope=="basic"
			@posts = Micropost.find(:all)	
		elsif scope=="date"
			@posts = Micropost.find_all_by_event_date([params[:start]..params[:end]])
		elsif scope=="dateunit"
			startdate = Date.strptime(params[:start], "%Y-%m-%d")
			enddate = Date.strptime(params[:end], "%Y-%m-%d")
			@posts = Micropost.all(:conditions => {
				:event_date => startdate..enddate, :unit=> params[:targetunit]})
		elsif scope=="full"
			@posts = Micropost.find_all_by_category_and_event_date_and_unit(params[:category], [params[:start]..params[:end]], params[:targetunit])
		end
			c << ["event_date", "user", "user.email", "user.unit", "defendant", "dob", "adf", "category", "content", "created_at", "jail", "probation", "community service", "judge", "lead charge", "convicted charges", "enhanced", "guidelines", "team leader"]
			@posts.each do |post|
				leader = User.new
				
				if !post.teamleader.blank? && !post.teamleader.nil?
					leader = User.find_by_id(post.teamleader)
				end
				
				if leader.nil?
					c << [post.event_date.to_s, post.user.name.to_s, post.user.email.to_s, post.user.unit.to_s, post.defendant.to_s, post.dob.to_s, post.adf.to_s, post.category.to_s, post.content.to_s, post.created_at.to_s, post.jail.to_s, post.probation.to_s, post.communityservice.to_s, post.judge.to_s, post.leadcharge.to_s, post.convictedcharges.to_s, post.enhanced.to_s, post.guidelines.to_s, ""]
				else
					c << [post.event_date.to_s, post.user.name.to_s, post.user.email.to_s, post.user.unit.to_s, post.defendant.to_s, post.dob.to_s, post.adf.to_s, post.category.to_s, post.content.to_s, post.created_at.to_s, post.jail.to_s, post.probation.to_s, post.communityservice.to_s, post.judge.to_s, post.leadcharge.to_s, post.convictedcharges.to_s, post.enhanced.to_s, post.guidelines.to_s, leader.name_comma]
				end
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
		if current_user.admin?
			@title = "All posts"
			@posts = Micropost.paginate(:page => params[:page], :per_page => 20).order('created_at DESC')
		elsif signed_in?
			@title = "Unit posts"
			@posts = Micropost.where(:unit=>current_user.unit).paginate(:page => params[:page], :per_page => 20).order('created_at DESC')
		else
			@posts = []
		end
	end

end
