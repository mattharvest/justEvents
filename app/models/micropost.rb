class Micropost < ActiveRecord::Base

	belongs_to :user
	attr_accessor :notify
	attr_accessible :dob, :adf, :defendant, :category, :casenumber, :event_date, :unit, :content, :casefile_id, :gang, :jail, :probation, :restitution, :offendertype, :communityservice, :judge, :leadcharge, :convictedcharges, :enhanced, :guidelines, :teamleader
	
	casenum_regex = /CR[0-9]E[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]|JA-[0-9][0-9]-[0-9][0-9][0-9][0-9]|CJ[0-9][0-9][0-9][0-9][0-9][0-9]|CA[0-9][0-9][0-9][0-9][0-9][0-9]|CT[0-9][0-9][0-9][0-9][0-9][0-9]|CT[0-9][0-9][0-9][0-9][0-9][0-9][A-Z]|CCN[0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]/i
	
	validates :content, :presence => true
	validates :casenumber, :presence => true

	default_scope :order => 'microposts.created_at DESC'
	
	def notify_of_call(user)
		UserMailer.call_notice(user, content.to_s, casenumber.to_s).deliver
	end
	
	def description
		casenumber.to_s+", "+unit.to_s+", "+category.to_s
	end
	
	def content_and_tags
		event_date.to_s+": "+defendant.to_s+", "+content.to_s + " ("+description+")" #NOTE: this is temp
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
			if @casefile.defendant.nil? || @casefile.defendant=="Doe, John"
				@casefile.defendant = self.defendant
			end
			@casefile.save
			@casefile
		else
			#this is serious...
		end
	end
end  
