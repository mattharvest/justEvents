class InvestigationsController < ApplicationController
	#:unit
	#:assignee_id
	#:assignor
	#:defendant
	#:arrest_date
	#:casenumber
	#:initial_appearance
	#:preliminary_hearing
	#:district_date
	#:district_room
	#:victim
	#:incident_date
	#:address
	#:synopsis
	before_filter :authenticate, :only => [:create, :destroy]
	before_filter :authorized_user, :only => :destroy
	before_filter :authorized_viewer, :only => :show
	
	def check_achievements
		investigation_count = current_user.investigations.count
		case investigation_count
			when 1
				flash[:investigationachievement1]="You made your first investigation!"
			when 10
				flash[:investigationachievement10]="You made your 10th investigation!"
			when 100
				flash[:investigationachievement100]="You made your 100th investigation!"
		end
	end
	
	def new
		@investigation = Investigation.new
	end
	
	def update_status
		@investigation = Investigation.find_by_id(params[:id])
		@investigation.status = params[:status]
		if @investigation.save
			investigation_post = current_user.microposts.build(:unit=>current_user.unit, :event_date=>Date.today.to_s, :content=>'Investigation updated to '+@investigation.current_status, :defendant=>@investigation.defendant, :category=>'investigation', :casenumber=>@investigation.get_casefile.lead_casenumber)
			if investigation_post.save
				flash[:investigationpostsuccess]="Assignment of investigation posted"
			else
				flash[:investigationpostfailure]="Assignment of investigation not posted!"
			end
		else
			flash[:investigationfailure]="Status not updated!"
		end
		redirect_to :back
	end
	
	def index		
		@investigations = Investigation.paginate(:page=>params[:page], :per_page=>20).order('updated_at DESC')
		@title = "Investigations"
	end
	
	def show
		@investigation = Investigation.find_by_id(params[:id])
		@title="Invesigation"
	end
	
	def create
		params[:investigation][:casenumber].upcase!
		@investigation = current_user.investigations.build(params[:investigation])
		@investigation.status=0 #sets it as ACTIVE to start
		@investigation.unit = current_user.unit
		@investigation.assignor=current_user.id
		if params[:investigation][:assignee_id].blank?
			@assignee = current_user
		else
			@assignee = User.find_by_id(params[:investigation][:assignee_id])
		end
		
		if @casefile = @investigation.get_casefile #should handle that via the model
		else
			flash[:investigationfailure]="Failed to find/create casefile!"
		end
		
		if @investigation.save
			check_achievements
			flash[:investigationsuccess]="Investigation created"
			#now create the ToDo for the assignee to review the case within 7 days
			assignee_todo = @assignee.todoitems.build(:duedate=>Date.today+7, :casenumber=>@casefile.lead_casenumber, :user_id=>@investigation.assignee_id, :content=>'Review this case for '+current_user.unit)
				#insert the email notice HERE
			if assignee_todo.save
				flash[:investigationtodosuccess]="ToDo for assignee created"
			else
				flash[:investigationtodofailure]="ToDo for assignee not created!"
			end
			
			#add the in-office notifications
			@notifications = []
			user_ids_to_notify = params[:investigation][:notifications]
			user_ids_to_notify.each do |p|
				if !p.blank?
					@notifications << User.find_by_id(p).email
				end
			end
			
			#add the external notifications
			if !params[:investigation][:external_notifications].nil?
				emails = params[:investigation][:external_notifications].split(',')
				emails.each do |e|
					if !e.blank?
						@notifications << e
					end
				end
			end

			#send the email to the assignee so they get a full report
			UserMailer.investigation_notice(current_user, @assignee, @investigation, @notifications).deliver

			
			#finally, create the event to reflect that it's been assigned
			investigation_post = current_user.microposts.build(:unit=>@assignee.unit, :event_date=>Date.today.to_s, :content=>'New investigation started by '+current_user.name+', assigned to '+@assignee.name+", notifications sent to "+@notifications.to_sentence, :defendant=>@investigation.defendant, :category=>'investigation', :casenumber=>@casefile.lead_casenumber)
			if investigation_post.save
				flash[:investigationpostsuccess]="Assignment of investigation posted"
			else
				flash[:investigationpostfailure]="Assignment of investigation not posted!"
			end
			redirect_to current_user
		else
			flash[:investigationfailure]="Investigation not created! "+"("+@investigation.errors.full_messages.to_s+")"
			redirect_to :back
		end
	end
	
	def destroy
		if @investigation.destroy
			flash[:investigationfailure] = "Investigation destroyed"
			redirect_to :back
		else
			flash[:investigationfailure] = "Investigation not destroyed"
			redirect_to :back
		end
	end
	
	def update
		@investigation = Investigation.find_by_id(params[:id])
	end
	
	private
		def authorized_user
			@investigation = current_user.investigations.find_by_id(params[:id])
			if !current_user.admin? 
				redirect_to root_path if @investigation.nil?
			else
				@investigation = Investigation.find_by_id(params[:id])
			end
		end
		
		def authorized_viewer
			@investigation = Investigation.find_by_id(params[:id])
			if current_user.admin?||current_user.unit==@investigation.unit||current_user.supervisor?
				@investigation
			else redirect_to root_path
			end
		end

end