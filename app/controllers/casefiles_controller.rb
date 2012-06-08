class CasefilesController < ApplicationController
	
  	def new
		@casefile = Casefile.new
	end
	
	def handle_todo
		assignee_todo = @assignee.todoitems.build(:duedate=>Date.today+7, :casenumber=>@casefile.lead_casenumber, :user_id=>@casefile.assignee_id, :content=>'Review this case for '+current_user.unit)
		if assignee_todo.save
			flash[:investigationtodosuccess]="ToDo for assignee created"
			assignee_todo.notify_of_todo(@assignee, current_user)
		else
			flash[:investigationtodofailure]="ToDo for assignee not created!"
		end
	end
	
	def create
		@casefile = Casefile.new
		if @casefile.update_attributes(params[:casefile])
			if @casefile.defendant.blank?||@casefile.defendant.nil?
				@casefile.defendant="Doe, John"
			end
			@notifications = []
			
			#handle the assignment
			if params[:casefile][:assignee_id].blank?
				@assignee = current_user			
			else
				@assignee = User.find_by_id(@casefile.assignee_id)
				handle_assignment
			end
			
			@notifications << @assignee.email

			#create the event to reflect that it's been assigned
			casefile_post = @assignee.microposts.build(:unit=>@assignee.unit, :event_date=>Date.today.to_s, :content=>'Case started by '+current_user.name+', assigned to '+@assignee.name+", notifications sent to "+@notifications.to_sentence, :defendant=>@casefile.defendant, :category=>'investigation', :casenumber=>@casefile.lead_casenumber)
			if casefile_post.save
				flash[:casefilepostsuccess]="Assignment of casefile posted"
			else
				flash[:casefilepostfailure]="Assignment of casefile not posted!"
			end
			
			
			#add the in-office notifications
			user_ids_to_notify = params[:casefile][:notifications]
			user_ids_to_notify.each do |p|
				if !p.blank?
					@notifications << User.find_by_id(p).email
				end
			end
			
			#add the external notifications
			if !params[:casefile][:external_notifications].nil?
				emails = params[:casefile][:external_notifications].split(',')
				emails.each do |e|
					if !e.blank?
						@notifications << e
					end
				end
			end
			
			#send the email to the assignee so they get a full report
			if !@notifications.blank?
				UserMailer.casefile_notice(current_user, @assignee, @casefile, @notifications).deliver
			end	
			
			#now create the ToDo for the assignee to review the case within 7 days
			handle_todo
			
			redirect_to @casefile
		else
			redirect_to :back
		end
	end
	
	
	def edit
		@casefile = Casefile.find(params[:id])
		@todoitem = Todoitem.new
		@micropost = Micropost.new
	end
	
	def update
		@casefile = Casefile.find(params[:id])
		if @casefile.update_attributes(params[:casefile])
			redirect_to :cases
		else
			render 'edit'
		end
	end
	
	def show
		@casefile = Casefile.find(params[:id])
		@title=@casefile.defendant
		@petition
		if !@casefile.ccn.blank?
			@petition = Petition.find_by_ccn(@casefile.ccn.tr("CCN", ""))
		end
		
		
		@investigation = @casefile.get_investigation

		@microposts = @casefile.get_microposts
		@todos = @casefile.get_todos.sort_by {|t| t.daysleft}
		
		@todoitem = Todoitem.new
		@micropost = Micropost.new
	end
	
	def destroy
		@casefile = Casefile.find(params[:id])
		if !@casefile.nil?
		
			if @casefile.destroy
				flash[:casefilesuccess] = "Casefile destroyed"
				redirect_to :cases
			else
				flash[:casefileerror] = "Casefile not destroyed"
				redirect_to :back
			end
		
		end
	end
	
	def index
		@casefiles = []
		if params[:search]
			#SEARCH MODE
			@searchstring = params[:search].upcase
			stub = @searchstring[0..1]
			if stub=="CR"
				@casefiles << Casefile.find_by_cr(@searchstring)
			elsif stub=="CT"
				@casefiles << Casefile.find_by_ct(@searchstring)
			elsif stub=="CJ"
				@casefiles << Casefile.find_by_cj(@searchstring)
			elsif stub=="CA"
				@casefiles << Casefile.find_by_ca(@searchstring)
			elsif stub=="SA"
				Casefile.find_all_by_sao(@searchstring).each do |c|
					@casefiles << c
				end
			elsif stub=="JA"
				@casefiles << Casefile.find_by_ja(@searchstring)
			elsif stub=="CC"
				Casefile.find_all_by_ccn(@searchstring).each do |c|
					@casefiles << c
				end
			else
				flash[:casefilefailure] = "Not a valid format for a casenumber."
				redirect_to :back
				return
			end
			
			if @casefiles.length==0
				flash[:casefilefailure] = "No cases found."
				
				redirect_to :back
			end
		end
	end
	
end
