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

		if stub=="CC"
			@casefile = Casefile.find_or_create_by_ccn(@micropost.casenumber)
		elsif stub=="CR"
			@casefile = Casefile.find_or_create_by_cr(@micropost.casenumber)
		elsif stub=="CT"
			@casefile = Casefile.find_or_create_by_ct(@micropost.casenumber)
		elsif stub=="CJ"
			@casefile = Casefile.find_or_create_by_cj(@micropost.casenumber)
		elsif stub=="CA"
			@casefile = Casefile.find_or_create_by_ca(@micropost.casenumber)
		elsif stub=="SA"
			@casefile = Casefile.find_or_create_by_sao(@micropost.casenumber)
		elsif stub=="JA"
			@casefile = Casefile.find_or_create_by_ja(@micropost.casenumber)
		end
		
		if @micropost.defendant.nil?
			@casefile.defendant="Doe, John"
		else
			@casefile.defendant=@micropost.defendant
		end
		
		if @casefile.save
			flash[:casefilesuccess]="Casefile created/saved"+@casefile.summary
		else
			flash[:casefilefailure]="Casefile not created, "+casefile.cr
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