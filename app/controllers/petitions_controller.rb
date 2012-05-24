class PetitionsController < ApplicationController
	before_filter :authorized_user, :only => :destroy
	def index
		@title="Index of Petitions"
		@petitions = Petition.find(:all)
	end
	
	def destroy
		@petition = Petition.find_by_id(params[:id])
		if @petition.destroy
			flash[:notice] = "Petition destroyed"
			redirect_to :back
		else
			flash[:notice] = "Petition not destroyed"
			redirect_to :back
		end
	end
	
	def new
		@petition = Petition.new
		@title="New Petition"
	end
	
	def create
		@petition = Petition.create(params[:petition])			
		if @petition.valid?
			#parse the statement selectors
			if params[:petition][:witness_statement_type_string]=="didn't give a "
				@petition.witness_statement_type=0
			elsif params[:petition][:witness_statement_type_string]=="gave a written "
				@petition.witness_statement_type=1
			elsif params[:petition][:witness_statement_type_string]=="gave an oral "
				@petition.witness_statement_type=2
			end

			if params[:petition][:respondent_statement_type_string]=="didn't give a "
				@petition.respondent_statement_type=0
			elsif params[:petition][:respondent_statement_type_string]=="gave a written "
				@petition.respondent_statement_type=1
			elsif params[:petition][:respondent_statement_type_string]=="gave an oral "
				@petition.respondent_statement_type=2
			end

			@petition.save
			flash[:petitionsuccess]="Success saving petition."
			
			#now, make a casefile
			@casefile = Casefile.new
				@casefile.ccn = "CCN"+@petition.ccn
				@casefile.defendant = @petition.defendant
				@casefile.assignee_id=current_user.id
				
			if @casefile.save
				flash[:petitioncasefilesuccess]="Casefile built based off petition."
				casefile_post = current_user.microposts.build(:unit=>current_user.unit, :event_date=>Date.today.to_s, :content=>'Case petitioned.', :defendant=>@casefile.defendant, :category=>'investigation', :casenumber=>@petition.ccn)
				casefile_post.save
				
				casefile_todo = current_user.todoitems.build(:duedate=>Date.today+7, :casenumber=>@casefile.ccn, :user_id=>current_user.id, :content=>'Review this case for '+current_user.unit)
				casefile_todo.save
			else
				flash[:petitioncasefilefailure]="Casefile for petition NOT built"
			end
			redirect_to @petition

		else
			flash[:error]="Failure saving petition."
			returnString=""
			@petition.errors.each do |attribute, message|
				if !attribute.to_s.blank?
					flash[(attribute.to_s+"failure").to_sym]=attribute.to_s.humanize+" "+message.to_s;
				end
			end
			render :action=>'new'
		end	
	end
		
	def show
		@petition = Petition.find(params[:id])
		@casefile = Casefile.find_by_ccn("CCN"+@petition.ccn)
		@title=@petition.defendant
	end
		private
		def authorized_user
			@petition = Petition.find_by_id(params[:id])
			if !current_user.admin? 
				redirect_to root_path
			else
				#
			end
		end
end
