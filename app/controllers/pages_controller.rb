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
	
	def current_events
		@title="This Week's Events"
		if current_user.admin?||current_user.unit=="administration"
			@posts = Micropost.find_all_by_created_at([7.days.ago..0.seconds.ago])
		else
			@posts = Micropost.find_all_by_unit_and_created_at(current_user.unit, [7.days.ago..0.seconds.ago])
		end
		
		@calls = []
		@pleas=[]
		@continuances=[]
		@trials=[]
		@warrants=[]
		@todoevents=[]
		#ADD THE REST OF THE CATEGORIES
		@posts.each do |p|
			case p.category
				when "phonecall","email"
					@calls << p
				when "plea"
					@pleas << p
				when "continuance"
					@continuances << p
				when "trial"
					@trials << p
				when "writ", "warrant"
					@warrants <<p
				when "todoitem"
					@todoevents<<p
				
			end
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
			@microposts=Micropost.paginate(:page => params[:page], :per_page => 20).order('created_at DESC')
			@unit_posts = Micropost.where(:unit=>current_user.unit).paginate(:page => params[:page], :per_page => 20).order('created_at DESC')
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
		@user_id = params[:target_user]
		@category = params[:micropost_category]
		@unit = params[:micropost_unit]
		if @unit.blank?
			@unit=current_user.unit
		end

		@category=params[:micropost_category]
		if @user_id.blank?&&@category.blank? #BOTH BLANK
			@microposts = Micropost.where(:event_date=>[params[:start]..params[:end]], :unit=>@unit)
		elsif @user_id.blank?&&!@category.blank? #USER blank, CATEGORY NOT
			@microposts = Micropost.where(:category=>@category, :event_date=>[params[:start]..params[:end]], :unit=>@unit)
		elsif !@user_id.blank?&&@category.blank? #USER not, CATEGORY BLANK
			@microposts = Micropost.where(:user_id=>@user_id, :event_date=>[params[:start]..params[:end]], :unit=>@unit)
		else #neither blank
			@microposts = Micropost.where(:user_id=>@user_id, :category=>params[:micropost_category], :event_date=>[params[:start]..params[:end]], :unit=>@unit)
		end
	end
	
	def last_week
		if !signed_in?
			return
		end
		unit=current_user.unit
		@microposts = @last_week
		export_to_csv
	end
	
	def export_to_csv
		if @microposts.nil?
			@microposts=Micropost.find(:all)
		end
		
		if params[:type]=="unit"
			@microposts=Micropost.where("unit=?", current_user.unit)
		elsif params[:type]=="self"
			@microposts=Micropost.where("user_id=?", current_user.id)
		elsif params[:type]=="lastweek"
			@microposts=Micropost.where(:unit=>current_user.unit, :event_date=>[Date.today-7..Date.today])
		elsif params[:type]=="custom"
			@microposts=Micropost.where(:category=>params[:micropost_category], :event_date=>[params[:start]..params[:end]], :unit=>current_user.unit)
		end
		
		csv_string = CSV.generate do |c|
			c << ["event_date", "user", "user.email", "user.unit", "defendant", "dob", "adf", "category", "content", "created_at", "jail", "probation", "community service", "judge", "lead charge", "convicted charges", "enhanced", "guidelines top", "guidelines bottom", "aba plea", "team leader"]
			@microposts.each do |post|
				leader = User.new
				
				if !post.teamleader.blank? && !post.teamleader.nil?
					leader = User.find_by_id(post.teamleader)
				end
				
				if leader.nil?
					c << [post.event_date.to_s, post.user.name.to_s, post.user.email.to_s, post.user.unit.to_s, post.defendant.to_s, post.dob.to_s, post.adf.to_s, post.category.to_s, post.content.to_s, post.created_at.to_s, post.jail.to_s, post.probation.to_s, post.communityservice.to_s, post.judge.to_s, post.leadcharge.to_s, post.convictedcharges.to_s, post.enhanced.to_s, post.guidelines_top.to_s, post.guidelines_bottom.to_s, post.aba.to_s, "", post.victims.to_s]
				else
					c << [post.event_date.to_s, post.user.name.to_s, post.user.email.to_s, post.user.unit.to_s, post.defendant.to_s, post.dob.to_s, post.adf.to_s, post.category.to_s, post.content.to_s, post.created_at.to_s, post.jail.to_s, post.probation.to_s, post.communityservice.to_s, post.judge.to_s, post.leadcharge.to_s, post.convictedcharges.to_s, post.enhanced.to_s, post.guidelines_top.to_s, post.guidelines_bottom.to_s, post.aba.to_s, leader.name_comma, post.victims.to_s]
				end
			end
		end
		
		send_data csv_string,
		:type => 'text/csv; charset=iso8859-1; header=present',
		:disposition => 'attachment; filename='+Time.now.to_s+'posts.csv'
	end
	

	def help
		@title = "Help"
	end
  
	def users
		@title = "Users"
	end
	
	def posts
		@title = "Posts"
			@all_posts = Micropost.where(:content=>"Case petitioned.")
			flash[:notice]=""
			@all_posts.each do |p|
				p.casenumber = p.casenumber.tr('ccn', '')
				p.casenumber="CCN"+p.casenumber
				flash[:notice]+="\n"+p.casenumber
				p.save
			end
		if current_user.admin?||current_user.supervisor?
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
