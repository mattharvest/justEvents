class Micropost < ActiveRecord::Base

	belongs_to :user
	has_and_belongs_to_many :tags
	

	casenum_regex = /CR[0-9]E[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]|JA-[0-9][0-9]-[0-9][0-9][0-9][0-9]|CJ[0-9][0-9][0-9][0-9][0-9][0-9]|CA[0-9][0-9][0-9][0-9][0-9][0-9]|CT[0-9][0-9][0-9][0-9][0-9][0-9]/i
	
	validates :content, :presence => true, :length => { :maximum => 255 }
	validates :user_id, :presence => true	
	validates :casenumber, :presence => true,
		:format   => { :with => casenum_regex }
	
	default_scope :order => 'microposts.created_at DESC'
	
	def description
		casenumber.to_s+", "+unit.to_s+", "+category.to_s+", "+event_date.to_s
	end
	
	def tags_used
		tempstring = "("+tags.count.to_s+" tags)"
		self.tags.each do |t|
			tempstring+=t.to_s
		end
		tempstring
	end
	
	def content_and_tags
		content + ", tags: "+description #NOTE: this is temp
	end
end  
