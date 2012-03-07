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
	
	def report_info
		tempstring = ""
		if user.name.nil?
			user.name='nil'
		end
		if user.email.nil?
			user.email='nil'
		end
		if casenumber.nil?
			casenumber='nil'
		end
		if adf.nil?
			adf="nil"
		end
		if content.nil?
			content='nil'
		end
		if unit.nil?
			unit='nil'
		end
		if category.nil?
			category='nil'
		end
		if !event_date.nil?
			eventstring = event_date.to_s
		else
			eventstring = "nil"
		end
		if !dob.nil?
			dobstring = dob.to_s
		else
			dobstring="nil"
		end
		tempstring=""
		tempstring+=eventstring+" | "
		tempstring+=user.name+" | "
		tempstring+=user.email+" | "
		tempstring+=casenumber+" | "
		tempstring+=adf+" | "
		tempstring+=dobstring+" | "
		tempstring+=content+" | "
		tempstring+=unit+" | "
		tempstring+=category+" | "
		tempstring+=created_at.to_s
	end
end  
