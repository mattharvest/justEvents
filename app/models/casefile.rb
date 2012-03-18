class Casefile < ActiveRecord::Base
	attr_accessor :lead_casenumber
	attr_accessible :ccn, :cr, :ct, :ca, :ca, :ja, :sao, :defendant
	
	casenum_regex = /CR[0-9]E[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]|JA-[0-9][0-9]-[0-9][0-9][0-9][0-9]|CJ[0-9][0-9][0-9][0-9][0-9][0-9]|CA[0-9][0-9][0-9][0-9][0-9][0-9]|CT[0-9][0-9][0-9][0-9][0-9][0-9]/i

	#validation isn't working at the moment....
	
	#validates :ccn, :format => { :with => /CCN[0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]/ }
	#validates :cr, :format => { :with => /CR[0-9]E[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]/ }
	#validates :ct, :format => { :with => /CT[0-9][0-9][0-9][0-9][0-9][0-9] }
	#validates :cj, :format => { :with => /CJ[0-9][0-9][0-9][0-9][0-9][0-9]/ }
	#validates :ca, :format => { :with => /CA[0-9][0-9][0-9][0-9][0-9][0-9]/ }
	#validates :ja, :format => { :with => /JA-[0-9][0-9]-[0-9][0-9][0-9][0-9]/ }
	
	def lead_casenumber
		if !ct.blank?
			ct
		elsif !cj.blank?
			cj
		elsif !ca.blank?
			ca
		elsif !cr.blank?
			cr
		elsif !ja.blank?
			ja
		else
			ccn
		end
	end
	
	def casenumber?(submitted_casenumber)
		(ccn==submitted_casenumber)||
		(cr==submitted_casenumber)||
		(ct==submitted_casenumber)||
		(cj==submitted_casenumber)||
		(ca==submitted_casenumber)||
		(sao==submitted_casenumber)||
		(ja==submitted_casenumber)
	end
	
	def get_microposts
		#find all associated microposts
		Micropost.find_all_by_casenumber(ccn)|
		Micropost.find_all_by_casenumber(cr)|
		Micropost.find_all_by_casenumber(ct)|
		Micropost.find_all_by_casenumber(cj)|
		Micropost.find_all_by_casenumber(ca)|
		Micropost.find_all_by_casenumber(sao)|
		Micropost.find_all_by_casenumber(ja)
	end
	
	def get_todos
		Todoitem.find_all_by_casenumber(ccn)|
		Todoitem.find_all_by_casenumber(cr)|
		Todoitem.find_all_by_casenumber(ct)|
		Todoitem.find_all_by_casenumber(cj)|
		Todoitem.find_all_by_casenumber(ca)|
		Todoitem.find_all_by_casenumber(sao)|
		Todoitem.find_all_by_casenumber(ja)	
	end
	
	def summary
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
