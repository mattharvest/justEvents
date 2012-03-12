class Todoitem < ActiveRecord::Base
	belongs_to :user
	
	attr_accessible :content, :duedate, :priority, :complete, :casenumber
	casenum_regex = /CR[0-9]E[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]|JA-[0-9][0-9]-[0-9][0-9][0-9][0-9]|CJ[0-9][0-9][0-9][0-9][0-9][0-9]|CA[0-9][0-9][0-9][0-9][0-9][0-9]|CT[0-9][0-9][0-9][0-9][0-9][0-9]/i
	
	validates :content, :presence => true
	validates :user_id, :presence => true
	validates :duedate, :presence => true
	validates :casenumber, :presence => true,
		:format   => { :with => casenum_regex }
	
	def summary
		content+" (due "+duedate.to_s+") ("+priority.to_s+")"
	end
	
end
