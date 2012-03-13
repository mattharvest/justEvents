class TodoitemsController < ApplicationController
	before_filter :authenticate, :only => [:create, :destroy]
	before_filter :authorized_user, :only => :destroy
	
	def create
		@todoitem = current_user.todoitems.build(params[:todoitem])
		if @todoitem.priority.nil?
			@todoitem.priority=1
		end
		@todoitem.complete=false
		
		stub = @todoitem.casenumber[0..1]

		if stub=="CC"
			@casefile = Casefile.find_or_create_by_ccn(@todoitem.casenumber)
		elsif stub=="CR"
			@casefile = Casefile.find_or_create_by_cr(@todoitem.casenumber)
		elsif stub=="CT"
			@casefile = Casefile.find_or_create_by_ct(@todoitem.casenumber)
		elsif stub=="CJ"
			@casefile = Casefile.find_or_create_by_cj(@todoitem.casenumber)
		elsif stub=="CA"
			@casefile = Casefile.find_or_create_by_ca(@todoitem.casenumber)
		elsif stub=="SA"
			@casefile = Casefile.find_or_create_by_sao(@todoitem.casenumber)
		elsif stub=="JA"
			@casefile = Casefile.find_or_create_by_ja(@todoitem.casenumber)
		end
		
		if @casefile.defendant.nil?
			@casefile.defendant="Doe, John"
		end
		
		if @casefile.save
			flash[:casefilesuccess]="Casefile created/saved"+@casefile.summary
		else
			flash[:casefilefailure]="Casefile not created, "+@casefile.summary
		end
		
		if @todoitem.save
			flash[:todoitemsuccess]= "Todo item created"
			#always go to where you were, so the different forms dont get confusing
			redirect_to :back
		else
			render 'pages/home'
		end
	end
	
	def destroy
		if @todoitem.destroy
			flash[:notice] = "Todo destroyed"
			redirect_to :back
		else
			flash[:notice] = "Todo not destroyed"
			redirect_to :back
		end
	end
	
	def update
		@todoitem = Todoitem.find_by_id(params[:id])
		if params[:complete]=="true"
			flash[:todonotice]="Task marked complete!"
			@todoitem.complete=true
		else
			flash[:todonotice]="Task not marked complete, "+params[:complete]
			@todoitem.complete=false
		end		
		@todoitem.save
		
		redirect_to :back
		
	end
	
	private
		def authorized_user
			@todoitem = current_user.todoitems.find_by_id(params[:id])
			if !current_user.admin? 
				redirect_to root_path if @todoitem.nil?
			else
				@todoitem = Todoitem.find_by_id(params[:id])
			end
		end
end
