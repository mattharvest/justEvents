class CasefilesController < ApplicationController

  	def new
		@casefile = current_user.casefiles.new
	end
	
	def create
		@casefile = current_user.casefiles.build(params[:casefile])
	end
	
	def destroy
		@casefile = Casefile.find(params[:id])
		if !@casefile.nil?
		
			if @casefile.destroy
				flash[:casefilesuccess] = "Casefile destroyed"
				redirect_to :back
			else
				flash[:casefileerror] = "Casefile not destroyed"
				redirect_to :back
			end
		
		end
	end
	
end
