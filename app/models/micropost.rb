class Micropost < ActiveRecord::Base

	belongs_to :user
	attr_accessible :defendant, :category, :casenumber, :event_date, :unit, :content
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
end  
