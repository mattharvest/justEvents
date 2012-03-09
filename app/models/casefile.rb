class Casefile < ActiveRecord::Base
	has_and_belongs_to_many :users
	
	attr_accessible :CCN, :CR, :CT, :CJ, :CA, :SAO
	
	casenum_regex = /CR[0-9]E[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]|JA-[0-9][0-9]-[0-9][0-9][0-9][0-9]|CJ[0-9][0-9][0-9][0-9][0-9][0-9]|CA[0-9][0-9][0-9][0-9][0-9][0-9]|CT[0-9][0-9][0-9][0-9][0-9][0-9]/i
	
	#validates :CCN, :format => { :with => casenum_regex }
	#validates :CR, :format => { :with => casenum_regex }
	#validates :CT, :format => { :with => casenum_regex }
	#validates :CJ, :format => { :with => casenum_regex }
	#validates :CA, :format => { :with => casenum_regex }
	
	
	def casenumber?(submitted_casenumber)
		(CCN==submitted_casenumber)||(CR==submitted_casenumber)||(CT==submitted_casenumber)||(CJ==submitted_casenumber)||(CA==submitted_casenumber)||(SAO==submitted_casenumber)
	end
	
	def microposts
		#find all associated microposts
	end
	
	def summary
		returnstring="CR: "+self.CR.to_s
	end
		
end
