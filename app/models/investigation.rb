class Investigation < ActiveRecord::Base
	belongs_to :user
	attr_accessor :current_status, :notifications, :external_notifications
	attr_accessible :status, :user_id, :unit, :assignee_id, :assignor, :defendant, :arrest_date, :casenumber, :initial_appearance, :preliminary_hearing, :district_date, :district_room, :victim, :incident_date, :address, :synopsis 
	validates :casenumber, :presence => true
	validates :synopsis, :presence=> true
	validates :defendant, :presence=> true
	
	def current_status
		if status==0
			"under investigation"
		elsif status==1
			"accepted for prosecution"
		elsif status==2
			"declined"
		elsif status=3
			"hiatus"
		else
			"under investigation"
		end
	end
	
	def get_casefile
		stub = casenumber[0..1]
		if self.defendant.nil?
			self.defendant="Doe, John"
		end
		
		#this ALWAYS updates the casefile, since it might have changed due to a casefile merge
		if stub=="CR"
			@casefile = Casefile.find_or_create_by_cr(casenumber)
		elsif stub=="CT"
			@casefile = Casefile.find_or_create_by_ct(casenumber)
		elsif stub=="CJ"
			@casefile = Casefile.find_or_create_by_cj(casenumber)
		elsif stub=="CA"
			@casefile = Casefile.find_or_create_by_ca(casenumber)
		elsif stub=="SA"
			@casefile = Casefile.find_or_create_by_sao(casenumber)
		elsif stub=="JA"
			@casefile = Casefile.find_or_create_by_ja(casenumber)
		elsif stub=="CC"
			@casefile = Casefile.find_or_create_by_ccn(casenumber)
		end
		if !@casefile.nil?
			casefile_id=@casefile.id
			if @casefile.defendant.blank? || @casefile.defendant=="Doe, John"
				@casefile.defendant = self.defendant
			else
				self.defendant = @casefile.defendant
			end
			@casefile.save
			@casefile
		end
	end
	
end
