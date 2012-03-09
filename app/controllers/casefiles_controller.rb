class CasefilesController < ApplicationController
  
  	def new
		@casefile = current_user.casefiles.build
		@casefile.CR="CR test"
		@casefile.CCN="CCN test"
		@casefile.CT="CT test"
		@casefile.CJ="CJ test"
		@casefile.CA="CA test"
		@casefile.SAO="SAO test"
		@casefile.save
	end
	
	def create
		@casefile = current_user.casefiles.build(params[:casefile])
	end
	
	def destroy
		if @casefile.destroy
			flash[:casefilesuccess] = "Casefile destroyed"
			redirect_to :back
		else
			flash[:casefileerror] = "Casefile not destroyed"
			redirect_to :back
		end
	end
	
end
