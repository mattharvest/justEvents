class Micropost < ActiveRecord::Base

	belongs_to :user
	attr_accessible :dob, :adf, :defendant, :category, :casenumber, :event_date, :unit, :content, :casefile_id
	has_and_belongs_to_many :tags
	
	casenum_regex = /CR[0-9]E[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]|JA-[0-9][0-9]-[0-9][0-9][0-9][0-9]|CJ[0-9][0-9][0-9][0-9][0-9][0-9]|CA[0-9][0-9][0-9][0-9][0-9][0-9]|CT[0-9][0-9][0-9][0-9][0-9][0-9]/i
	
	validates :content, :presence => true
	validates :user_id, :presence => true	
	validates :casenumber, :presence => true,
		:format   => { :with => casenum_regex }
	
	default_scope :order => 'microposts.created_at DESC'
	
	def description
		casenumber+", "+unit+", "+category
	end
	
	def content_and_tags
		if self.defendant.nil?
			self.defendant="Doe, John"
		end
		event_date.to_s+": "+defendant+", "+content + " ("+description+")" #NOTE: this is temp
	end
	
	def get_casefile
		stub = casenumber[0..1]

		if stub=="CC"
			@casefile = Casefile.find_or_create_by_ccn(casenumber)
		elsif stub=="CR"
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
		end
		casefile_id=@casefile.id
		@casefile
	end
end  
