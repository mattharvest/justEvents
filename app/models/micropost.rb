class Micropost < ActiveRecord::Base
	attr_accessible :content, :casenumber, :category, :event_date, :unit
	
	belongs_to :user
	has_and_belongs_to_many :tags
	
	validates :content, :presence => true, :length => { :maximum => 255 }
	validates :user_id, :presence => true	
	validates :casenumber, :presence => true
	
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
	
	def report_info
		event_date.to_s+" | "+user.name+" | "+casenumber.to_s+" | "+content+" | "+unit.to_s+" | "+category.to_s
	end
end  
