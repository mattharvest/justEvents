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
		if !params[:todoitem][:user_id].blank?
			target_user = User.find_by_id(params[:todoitem][:user_id])
			@todoitem = target_user.todoitems.new(params[:todoitem])
			@todoitem.notify_of_todo(target_user)
		else
			@todoitem = current_user.todoitems.new(params[:todoitem])
			
		end
		
		if @todoitem.priority.nil?
			@todoitem.priority=1
		end
		
		if @todoitem.duedate.nil?
			@todoitem.duedate = Date.today+14
		end
		
		@todoitem.complete=false
		
		if @todoitem.save
			if !params[:todoitem][:user_id].blank?
				@todoitem.notify_of_todo(User.find_by_id(params[:todoitem][:user_id]))
			end
			
			flash[:todoitemsuccess]= "Todo item created"
			#always go to where you were, so the different forms dont get confusing
			@casefile = get_casefile(@todoitem.casenumber)
			
			if @casefile.defendant.nil?
				@casefile.defendant="Doe, John"
			end
			
			@casefile.save
			redirect_to @casefile and return
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
		if @todoitem = Todoitem.find_or_create_by_id(params[:id])
		else
			flash[:todonotice2]="Failed to find or create by ID the Todo here"
		end
		if params[:complete]=="true"
			flash[:todonotice]="Task marked complete!"
			@todoitem.complete=true
			
			@casefile = get_casefile(@todoitem.casenumber)
			
			@micropost = current_user.microposts.build(
				:defendant => @casefile.defendant,
				:casenumber => @todoitem.casenumber,
				:content => "Todo Completed: "+@todoitem.content,
				:event_date => Date.today,
				:category => "todoitem",
				:unit => current_user.unit
				)
			@micropost.save
		elsif !params[:todoitem][:duedate].nil?
			#update the date
			@todoitem.duedate=params[:todoitem][:duedate]
			@casefile = get_casefile(@todoitem.casenumber)
			flash[:todosuccess]="Duedate updated, now "+params[:todoitem][:duedate]
			
			@micropost = current_user.microposts.build(
				:defendant=>@casefile.defendant,
				:casenumber=>@todoitem.casenumber,
				:content=>"("+@todoitem.content+") now due "+@todoitem.duedate.to_s,
				:event_date=>Date.today,
				:category=>"todoitem",
				:unit => current_user.unit
				)
			@micropost.save
		else
			flash[:todonotice]="Task not updated"
		end
		
		if @todoitem.save
		else
			flash[:todofailure]="Todo not saved!"
		end
		
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
