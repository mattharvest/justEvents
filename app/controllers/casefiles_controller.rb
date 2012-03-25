class CasefilesController < ApplicationController

  	def new
		@casefile = Casefile.new
	end
	
	def create
		@casefile = Casefile.new
		if @casefile.update_attributes(params[:casefile])
			redirect_to :cases
		else
			render 'new'
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

		@microposts = @casefile.get_microposts
		@todos = @casefile.get_todos.sort_by {|t| t.daysleft}
		
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
