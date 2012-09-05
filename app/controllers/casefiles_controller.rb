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
			end
			
			@notifications << @assignee.email.to_s

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
		@petitions
		if !@casefile.ccn.blank?
			@petitions = Petition.find_all_by_ccn(@casefile.ccn.tr("CCN", ""))
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
		@name_cases=[]
		@casenumber_cases=[]
		
		if params[:search]
			#SEARCH MODE
			@searchstring = params[:search].upcase
			#@casefiles << Casefile.find_by_cr(@searchstring)
			#@casefiles << Casefile.find_by_ct(@searchstring)
			#@casefiles << Casefile.find_by_cj(@searchstring)
			#@casefiles << Casefile.find_by_ca(@searchstring)
			#Casefile.find_all_by_sao(@searchstring).each do |c|
			#	@casefiles << c
			#	end
			#@casefiles << Casefile.find_by_ja(@searchstring)
			#Casefile.find_all_by_ccn(@searchstring).each do |c|
			#	@casefiles << c
			#	end
			#Casefile.with_defendant_like(@searchstring).each do |c|
			#	@casefiles << c
			#end

			Casefile.with_cr_like(@searchstring).each do |c|
				@casefiles << c
				end
			Casefile.with_ct_like(@searchstring).each do |c|
				@casefiles << c
				end
			Casefile.with_cj_like(@searchstring).each do |c|
				@casefiles << c
				end
			Casefile.with_ca_like(@searchstring).each do |c|
				@casefiles << c
				end
			Casefile.with_ja_like(@searchstring).each do |c|
				@casefiles << c
				end
			Casefile.find_all_by_sao(@searchstring).each do |c|
				@casefiles << c
				end
			Casefile.with_ccn_like(@searchstring).each do |c|
				@casefiles << c
				end
			Casefile.with_defendant_like(@searchstring).each do |c|
				@casefiles << c
			end	
			petitions=[]
			Petition.with_statement_of_pc_like(@searchstring).each do |petition|
				petitions << petition
			end
			Petition.with_charges_like(@searchstring).each do |petition|
				petitions << petition
			end
				
			petitions.each do |petition|
				petition.associated_cases.each do |casefile|
					@casefiles << casefile
				end
			end
			
			@casefiles = @casefiles.paginate(:page=>params[:page], :per_page=>30 )
			
			
			if @casefiles.length==0
				flash[:casefilefailure] = "No cases found.  Would you like to create one?"
				redirect_to new_case_path and return
			elsif @casefiles.length==1
				if !@casefiles[0].nil?
					flash[:casefilesuccess]="Only one case found, loading it now!"
					redirect_to @casefiles[0] and return
				end
			end
			
		end
	end
	
end
