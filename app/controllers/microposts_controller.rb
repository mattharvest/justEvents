class MicropostsController < ApplicationController
	before_filter :authenticate, :only => [:create, :destroy]
	before_filter :authorized_user, :only => :destroy
	
	def new
	end

	
	def create
		params[:micropost][:casenumber].upcase!
		@micropost = current_user.microposts.new(params[:micropost])
		if @micropost.event_date.nil?||@micropost.event_date.blank?
			@micropost.event_date = @micropost.created_at
		end
		
		@micropost.unit = current_user.unit
		
		if @micropost.save
			flash[:micropostsuccess]= "Micropost created"
			@casefile = @micropost.get_casefile
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