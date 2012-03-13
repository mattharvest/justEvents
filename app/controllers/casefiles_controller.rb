class CasefilesController < ApplicationController

  	def new
		@casefile = current_user.casefiles.new
	end
	
	def create
		@casefile = current_user.casefiles.build(params[:casefile])
	end
	
	def show
		@casefile = Casefile.find(params[:id])
		@title=@casefile.defendant

		@microposts = @casefile.get_microposts
		@todos = @casefile.get_todos

		flash[:notice]="Microposts: "+@microposts.count.to_s+", Todos: "+@todos.count.to_s
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
	
end
