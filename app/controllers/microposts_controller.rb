class MicropostsController < ApplicationController
	before_filter :authenticate, :only => [:create, :destroy]
	before_filter :authorized_user, :only => :destroy
	
	def index
	end
	
	def create
		params[:micropost][:casenumber].upcase!
		@micropost = current_user.microposts.build(params[:micropost])
		if !@micropost.dob.nil?
			@micropost.dob = Date.parse(params[:micropost][:dob])
		end
		if !@micropost.event_date.nil?
			@micropost.event_date = Date.parse(params[:micropost][:event_date])
		end
		@micropost.unit = current_user.unit
		
		@casefile = @micropost.get_casefile
		
		if @casefile.save
			flash[:casefilesuccess]="Casefile created/saved"+@casefile.summary
		else
			flash[:casefilefailure]="Casefile not created, "+@casefile.summary
		end
		
		if @micropost.save
			flash[:micropostsuccess]= "Micropost created"
			#always go to where you were, so the different Micropost forms dont get confusing
			redirect_to :back
		else
			@feed_items=[]
			render 'pages/home'
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