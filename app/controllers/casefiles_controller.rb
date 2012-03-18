class CasefilesController < ApplicationController

  	def new
		@casefile = Casefile.new
	end
	
	def create
		@casefile = Casefile.build(params[:casefile])
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

		@microposts = @casefile.get_microposts
		@todos = @casefile.get_todos
		
		@todoitem = Todoitem.new
		@micropost = Micropost.new

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
