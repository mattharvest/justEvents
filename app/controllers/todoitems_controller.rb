class TodoitemsController < ApplicationController
	before_filter :authenticate, :only => [:create, :destroy]
	before_filter :authorized_user, :only => :destroy
	
	def check_achievements
		todo_count = current_user.todoitems.count
		case todo_count
			when 1
				flash[:todoachievement1]="You made your first todo!"
			when 10
				flash[:todoachievement10]="You made your 10th todo!"
			when 100
				flash[:todoachievement100]="You made your 100th todo!"
		end
	end
	
	def get_casefile(casenum)
		stub = casenum[0..1]
		if stub=="CC"
			Casefile.find_or_create_by_ccn(casenum.upcase)
		elsif stub=="CR"
			Casefile.find_or_create_by_cr(casenum.upcase)
		elsif stub=="CT"
			Casefile.find_or_create_by_ct(casenum.upcase)
		elsif stub=="CJ"
			Casefile.find_or_create_by_cj(casenum.upcase)
		elsif stub=="CA"
			Casefile.find_or_create_by_ca(casenum.upcase)
		elsif stub=="SA"
			Casefile.find_or_create_by_sao(casenum.upcase)
		elsif stub=="JA"
			Casefile.find_or_create_by_ja(casenum.upcase)
		else
			false
		end
	
	end
	
	def create
		params[:todoitem][:casenumber].upcase!
		if !params[:todoitem][:user_id].blank?
			target_user = User.find_by_id(params[:todoitem][:user_id])
			@todoitem = target_user.todoitems.new(params[:todoitem])
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
			check_achievements
			if !params[:todoitem][:user_id].blank?
				if @todoitem.notify_of_todo(User.find_by_id(params[:todoitem][:user_id]), current_user)
					flash[:todomailsuccess]="notification sent by email"
				else
					flash[:todomailfailure]="notification by email of todo failed"
				end
			end
			
			flash[:todoitemsuccess]= "Todo item created"
			#always go to where you were, so the different forms dont get confusing
			@casefile = get_casefile(@todoitem.casenumber)
			
			if @casefile.defendant.nil?
				@casefile.defendant="Doe, John"
			end
			
			if params[:todoitem][:precomplete].to_s=="1" #marked to complete
				@todoitem.complete=true	
				flash[:todonotice]="Task marked complete!"
				@micropost = current_user.microposts.build(
					:defendant => @casefile.defendant,
					:casenumber => @todoitem.casenumber,
					:content => "Todo Completed: "+@todoitem.content,
					:event_date => Date.today,
					:category => "todoitem",
					:unit => current_user.unit
					)
				@todoitem.save
				@micropost.save
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
			@todoitem.notify_of_todo(User.find_by_id(@todoitem.user_id), current_user)
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
