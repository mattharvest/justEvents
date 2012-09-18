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
		export_to_csv(@microposts)
	end
	
	def custom_petition_report
		@title="Petition search"
		@start_date=params[:start]
		@end_date=params[:end]
		@petitions = Petition.where(:created_at=>[@start_date..@end_date])
		export_petitions_to_csv(@petitions)
	end
	
	def last_week
		if !signed_in?
			return
		end
		unit=current_user.unit
		@microposts = Micropost.where(:user_id=>@user_id, :event_date=>[7.days.ago..0.seconds.ago])
		export_to_csv(@microposts)
	end
	
	def export_petitions_to_csv(petitions)
		@petitions=petitions
		
		if !@petitions.nil?
			csv_string = CSV.generate do |c|
				#c << ["Respondent", "Created At", "CCN", "ASA"]
				c << ["ccn", "asa", "asa_email", "defendant", "defendant_address", "defendant_dob", "school", "parent", "victim", "victim_address", "victim_adult_or_minor", "charges", "cpo_id", "cpo_name", "CPO agency", "assisting_officers", "witnesses", "chemist", "pwid", "fingerprint", "examiner", "tech", "counterfeit", "expert_content", "corespondents", "incident_report", "statement_of_respondent", "statement_of_corespondents_etc", "victim_witness_list", "arrest_report", "investigation_report", "accident_report", "screening_apt", "statement_of_pc", "incident_address", "mitigation", "search_and_seizures", "respondent_statement_type", "respondent_statement", "witness_statement_type", "witness_statement", "premerits_id", "medical_records", "business_records", "police_records", "mva_records", "other_records", "other_description", "offense_date", "email_address,", "soft_due_date", "hard_due_date", "submitted"]
				@petitions.each do |petition|
					#c<< [petition.defendant, petition.created_at.to_s, petition.ccn, petition.asa]
					c<<[petition.ccn, petition.asa, petition.asa_email, petition.defendant, petition.defendant_address, petition.defendant_dob, petition.school, petition.parent, petition.victim, petition.victim_address, petition.victim_adult_or_minor, petition.charges, petition.cpo_id, petition.cpo_name, petition.agency, petition.assisting_officers, petition.witnesses, petition.chemist, petition.pwid, petition.fingerprint, petition.examiner, petition.tech, petition.counterfeit, 	petition.expert_content, petition.corespondents, petition.incident_report, petition.statement_of_respondent, petition.statement_of_corespondents_etc, petition.victim_witness_list, petition.arrest_report, petition.investigation_report, petition.accident_report, petition.screening_apt, petition.statement_of_pc, petition.incident_address, 	petition.mitigation, petition.search_and_seizures, petition.respondent_statement_type, petition.respondent_statement, petition.witness_statement_type, petition.witness_statement, petition.premerits_id, petition.medical_records, petition.business_records, petition.police_records, petition.mva_records, petition.other_records, petition.other_description, petition.offense_date, petition.email_address, petition.soft_due_date, petition.hard_due_date, petition.created_at]
				end
			end
			
			send_data csv_string,
			:type => 'text/csv; charset=iso8859-1; header=present',
			:disposition => 'attachment; filename='+Time.now.to_s+'petitions.csv'		
		else
			flash[:petition_csv_error]="Petitions were nil!"
		end
		
	end
	
	def export_to_csv(microposts)
		@microposts=microposts
		
		csv_string = CSV.generate do |c|
			c << ["event_date", "user", "casenumber", "user.email", "user.unit", "defendant", "dob", "adf", "category", "content", "created_at", "victims"]
			@microposts.each do |post|
				c << [post.event_date.to_s, post.user.name.to_s, post.casenumber.to_s, post.user.email.to_s, post.user.unit.to_s, post.defendant.to_s, post.dob.to_s, post.adf.to_s, post.category.to_s, post.content.to_s, post.created_at.to_s, post.victims.to_s]
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
