class PetitionsController < ApplicationController
	def index
		@title="Index of Petitions"
		@petitions = Petition.find(:all)
		
	end
	
	def new
		@petition = Petition.new
		@title="New Petition"
	end
	
	def create
		@petition = Petition.create(params[:petition])			
		if @petition.valid?
			#parse the statement selectors
			if params[:additional][:witness_statement_type_string]=="didn't give a "
				@petition.witness_statement_type=0
			elsif params[:additional][:witness_statement_type_string]=="gave a written "
				@petition.witness_statement_type=1
			elsif params[:additional][:witness_statement_type_string]=="gave an oral "
				@petition.witness_statement_type=2
			end

			if params[:additional][:respondent_statement_type_string]=="didn't give a "
				@petition.respondent_statement_type=0
			elsif params[:additional][:respondent_statement_type_string]=="gave a written "
				@petition.respondent_statement_type=1
			elsif params[:additional][:respondent_statement_type_string]=="gave an oral "
				@petition.respondent_statement_type=2
			end

			@petition.save
			flash[:petitionsuccess]="Success saving petition."
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
		@title=@petition.defendant
	end
	
	def destroy
	end
	
end
