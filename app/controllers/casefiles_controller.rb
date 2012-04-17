class CasefilesController < ApplicationController
	
  	def new
		@casefile = Casefile.new
	end
	
	def create
		@casefile = Casefile.new
		if @casefile.update_attributes(params[:casefile])
			#add the in-office notifications
			@notifications = []
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
			UserMailer.casefile_notice(current_user, @casefile, @notifications).deliver
			
			redirect_to @casefile
		else
			redirect back
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
			@searchstring = params[:search]
			stub = @searchstring[0..1]
			if stub=="CR"
				@casefiles << Casefile.find_by_cr(params[:search])
			elsif stub=="CT"
				@casefiles << Casefile.find_by_ct(params[:search])
			elsif stub=="CJ"
				@casefiles << Casefile.find_by_cj(params[:search])
			elsif stub=="CA"
				@casefiles << Casefile.find_by_ca(params[:search])
			elsif stub=="SA"
				Casefile.find_all_by_sao(params[:search]).each do |c|
					@casefiles << c
				end
			elsif stub=="JA"
				@casefiles << Casefile.find_by_ja(params[:search])
			elsif stub=="CC"
				Casefile.find_all_by_ccn(params[:search]).each do |c|
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
