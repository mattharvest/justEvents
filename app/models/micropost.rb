class Micropost < ActiveRecord::Base
	attr_accessible :content, :casenumber, :category, :event_date, :unit
	
	belongs_to :user
	has_and_belongs_to_many :tags
	
	validates :content, :presence => true, :length => { :maximum => 255 }
	validates :user_id, :presence => true	
	
	default_scope :order => 'microposts.created_at DESC'
	
	def description
		self.unit.to_s+", "+self.casenumber.to_s+", "+self.category.to_s+", "+self.event_date.to_s
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
