class MicropostsController < ApplicationController
	before_filter :authenticate, :only => [:create, :destroy]
	before_filter :authorized_user, :only => :destroy
	
	def new
		@micropost = Micropost.new
	end

	def check_achievements
		post_count = current_user.microposts.count
		case post_count
			when 1
				flash[:micropostachievement1]="You made your first post!"
			when 10
				flash[:micropostachievement10]="You made your 10th post!"
			when 100
				flash[:micropostachievement100]="You made your 100th post!"
		end
	end
	
	def create
		params[:micropost][:casenumber].upcase!
		
		@micropost = current_user.microposts.new(params[:micropost])
		@micropost.defendant = params[:micropost][:defendant].to_s.titlecase
		if @micropost.event_date.nil?||@micropost.event_date.blank?
			@micropost.event_date = @micropost.created_at
		end
		
		@micropost.unit = current_user.unit
		
		if @micropost.category  =="referred to SI"
			#create a todo item for Ruddy in particular
			@ruddy = User.find_by_id(18) #NOTE THE HARDCODED VALUE HERE!!!
			if !@ruddy.nil?
				si_todo = @ruddy.todoitems.build(
					:duedate=>Date.today+7, 
					:casenumber=>@micropost.casenumber, 
					:user_id=>@ruddy.id, 
					:content=>'Review this case, as requested by '+current_user.name
					)
				if si_todo.save
					flash[:todosuccess]="SIU notified of your referral."
				else
					flash[:todofailure]="SIU not notfied!"
				end
			end
		end
		
		if @micropost.save
			check_achievements
			flash[:micropostsuccess]= "Micropost created"
			@casefile = @micropost.get_casefile
			if @micropost.defendant.to_s.blank?
				@micropost.defendant=@casefile.defendant
			end
			if @casefile.save
				flash[:casefilesuccess]="Casefile created/saved, "+@casefile.summary
				redirect_to @casefile and return
			else
				flash[:casefilefailure]="Casefile not created, "+@casefile.summary
				redirect_to :back
			end
		else
			@feed_items=[]
			flash[:micropostfailure]="Micropost not created, "+@micropost.casenumber
			flash[:errorsnotice]=@micropost.errors.full_messages
			redirect_to :back
		end
		
		if (@micropost.category=="phonecall")&&!(params[:micropost][:notify]=="")
			@micropost.notify_of_call(User.find_by_id(params[:micropost][:notify]))
			
			flash[:phonecallnotice]="Notice of phone call sent"
		end
	end
	
	def destroy
		if @micropost.destroy
			flash[:notice] = "Micropost destroyed"
			redirect_to :back
		else
			flash[:notice] = "Micropost not destroyed"
			redirect_to :back
		end
	end
	
	
	private
		def authorized_user
			@micropost = current_user.microposts.find_by_id(params[:id])
			if !current_user.admin? 
				redirect_to root_path if @micropost.nil?
			else
				@micropost = Micropost.find_by_id(params[:id])
			end
		end
end