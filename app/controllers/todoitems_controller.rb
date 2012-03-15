class TodoitemsController < ApplicationController
	before_filter :authenticate, :only => [:create, :destroy]
	before_filter :authorized_user, :only => :destroy
	
	
	def get_casefile(casenum)
		stub = casenum[0..1]
		if stub=="CC"
			Casefile.find_or_create_by_ccn(@todoitem.casenumber)
		elsif stub=="CR"
			Casefile.find_or_create_by_cr(@todoitem.casenumber)
		elsif stub=="CT"
			Casefile.find_or_create_by_ct(@todoitem.casenumber)
		elsif stub=="CJ"
			Casefile.find_or_create_by_cj(@todoitem.casenumber)
		elsif stub=="CA"
			Casefile.find_or_create_by_ca(@todoitem.casenumber)
		elsif stub=="SA"
			Casefile.find_or_create_by_sao(@todoitem.casenumber)
		elsif stub=="JA"
			Casefile.find_or_create_by_ja(@todoitem.casenumber)
		else
			false
		end
	
	end
	
	def create
		params[:todoitem][:casenumber].upcase!
		@todoitem = current_user.todoitems.new(params[:todoitem])
		if @todoitem.priority.nil?
			@todoitem.priority=1
		end
		@todoitem.complete=false
		
		if @todoitem.save
			flash[:todoitemsuccess]= "Todo item created"
			#always go to where you were, so the different forms dont get confusing
			@casefile = get_casefile(@todoitem.casenumber)
			
			if @casefile.defendant.nil?
				@casefile.defendant="Doe, John"
			end
			
			if @casefile.save
				flash[:casefilesuccess]="Casefile created/saved"+@casefile.summary
			else
				flash[:casefilefailure]="Casefile not created, "+@casefile.summary
			end
		else
			flash[:todoitemfailure]=@todoitem.errors.full_messages
		end
		redirect_to :back
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
			
			@casefile = get_casefile(@todoitem.casenumber)
			
			@micropost = current_user.microposts.build(
				:defendant => @casefile.defendant,
				:casenumber => @todoitem.casenumber,
				:content => "Todo Completed: "+@todoitem.content,
				:event_date => Date.today,
				:category => "todoitem"
				)
			@micropost.save
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
