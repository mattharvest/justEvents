class Casefile < ActiveRecord::Base
	
	attr_accessible :ccn, :cr, :ct, :ca, :ca, :ja, :sao, :defendant
	
	casenum_regex = /CR[0-9]E[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]|JA-[0-9][0-9]-[0-9][0-9][0-9][0-9]|CJ[0-9][0-9][0-9][0-9][0-9][0-9]|CA[0-9][0-9][0-9][0-9][0-9][0-9]|CT[0-9][0-9][0-9][0-9][0-9][0-9]|CT[0-9][0-9][0-9][0-9][0-9][0-9][A-Z]/i
	
	#validates :CCN, :format => { :with => casenum_regex }
	#validates :CR, :format => { :with => casenum_regex }
	#validates :CT, :format => { :with => casenum_regex }
	#validates :CJ, :format => { :with => casenum_regex }
	#validates :CA, :format => { :with => casenum_regex }
	#validates :JA, :format => { :with => casenum_regex }
	
	
	def casenumber?(submitted_casenumber)
		(ccn==submitted_casenumber)||
		(cr==submitted_casenumber)||
		(ct==submitted_casenumber)||
		(cj==submitted_casenumber)||
		(ca==submitted_casenumber)||
		(sao==submitted_casenumber)||
		(ja==submitted_casenumber)
	end
	
	def microposts
		#find all associated microposts
	end
	
	def summary
		if ccn.nil?
			ccn="[blank]"
		end
		if cr.nil?
			cr="[blank]"
		end
		if ct.nil?
			ct="[blank]"
		end
		if ca.nil?
			ca="[blank]"
		end
		if cj.nil?
			cj="[blank]"
		end
		if ja.nil?
			ja="[blank]"
		end
		if sao.nil?
			sao="[blank]"
		end
		if defendant.nil?
			defendant="Doe, John"
		end
		returnstring=
			"CCN: "+self.ccn.to_s+
			", CR: "+self.cr.to_s+
			", CT: "+self.ct.to_s+
			", CA: "+self.ca.to_s+
			", CJ: "+self.cj.to_s+
			", JA: "+self.ja.to_s+
			", SAO: "+self.sao.to_s+
			", "+self.defendant
	end
		
end
