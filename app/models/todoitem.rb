class Todoitem < ActiveRecord::Base
	belongs_to :user
	
	attr_accessor :daysleft
	
	attr_accessible :content, :duedate, :priority, :complete, :casenumber, :user_id
	casenum_regex = /CR[0-9]E[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]|JA-[0-9][0-9]-[0-9][0-9][0-9][0-9]|CJ[0-9][0-9][0-9][0-9][0-9][0-9]|CA[0-9][0-9][0-9][0-9][0-9][0-9]|CT[0-9][0-9][0-9][0-9][0-9][0-9]/i
	
	validates :content, :presence => true
	validates :user_id, :presence => true
	validates :duedate, :presence => true
	validates :casenumber, :presence => true
	
	def daysleft
		(duedate-Date.today).to_i
	end
	
	def summary
		if complete
			content+" (completed on "+updated_at.to_s+")"
		else
			content+" (due "+duedate.to_s+")"
		end
	end
	
	def retrieve_casefile
		stub = casenumber[0..1]
		
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
		else
			false
		end
	end
	
end
