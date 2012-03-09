class MicropostsController < ApplicationController
	before_filter :authenticate, :only => [:create, :destroy]
	before_filter :authorized_user, :only => :destroy
	
	def index
	end
	
	def create
		@micropost = current_user.microposts.build(params[:micropost])
		if !@micropost.dob.nil?
			@micropost.dob = Date.parse(params[:micropost][:dob])
		end
		if !@micropost.event_date.nil?
			@micropost.event_date = Date.parse(params[:micropost][:event_date])
		end
		@micropost.unit = current_user.unit
		
		stub = @micropost.casenumber[0..1]
		casefile = Casefile.Build(:CR=>@micropost.casenumber)
		
		if stub=="CC"
			casefile = Casefile.find_or_create_by_CCN(@micropost.casenumber)
		elsif stub=="CR"
			casefile = Casefile.find_or_create_by_CR(@micropost.casenumber)
		elsif stub=="CT"
			casefile = Casefile.find_or_create_by_CT(@micropost.casenumber)
		elsif stub=="CJ"
			casefile = Casefile.find_or_create_by_CJ(@micropost.casenumber)
		elsif stub=="CA"
			casefile = Casefile.find_or_create_by_CA(@micropost.casenumber)
		elsif stub=="SAO"
			casefile = Casefile.find_or_create_by_SAO(@micropost.casenumber)
		end
		
		if casefile.save
			flash[:success]="Casefile created/saved"
		else
			flash[:failure]="Casefile not created"
		end
		
		if @micropost.save
			flash[:success] = "Micropost created"
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