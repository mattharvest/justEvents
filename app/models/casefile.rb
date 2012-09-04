class Casefile < ActiveRecord::Base
	attr_accessor :lead_casenumber, :notifications, :external_notifications, :assignee_id
	attr_accessible :ccn, :cr, :ct, :ca, :cj, :ca, :ja, :sao, :defendant, :victims, :notifications, :external_notifications, :assignee_id
	
	casenum_regex = /CR[0-9]E[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]|JA-[0-9][0-9]-[0-9][0-9][0-9][0-9]|CJ[0-9][0-9][0-9][0-9][0-9][0-9]|CA[0-9][0-9][0-9][0-9][0-9][0-9]|CT[0-9][0-9][0-9][0-9][0-9][0-9]/i
	
	scope :with_defendant_like, lambda { |str|
			{
				:conditions => ['lower(defendant) like ?', "%#{str.downcase}%"]
			}
		}		
	
	
	validates :cr, :uniqueness => { :case_sensitive => false }, :allow_blank => true
	validates :ct, :uniqueness => { :case_sensitive => false }, :allow_blank => true
	validates :cj, :uniqueness => { :case_sensitive => false }, :allow_blank => true
	validates :ca, :uniqueness => { :case_sensitive => false }, :allow_blank => true
	validates :ja, :uniqueness => { :case_sensitive => false }, :allow_blank => true
	validates :defendant, :presence=>true
	
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
		elsif !ccn.blank?
			ccn
		else
			sao.to_s
		end
	end
	
	def get_investigation
		ccn_investigation = Investigation.find_by_casenumber(ccn)
		sao_investigation = Investigation.find_by_casenumber(sao)
		ct_investigation = Investigation.find_by_casenumber(ct)
		cj_investigation = Investigation.find_by_casenumber(cj)
		ca_investigation = Investigation.find_by_casenumber(ca)
		cr_investigation = Investigation.find_by_casenumber(cr)
		ja_investigation = Investigation.find_by_casenumber(ja)
		
		if !ccn_investigation.nil?
			ccn_investigation
		elsif !sao_investigation.nil?
			sao_investigation
		elsif !ct_investigation.nil?
			ct_investigation
		elsif !cj_investigation.nil?
			cj_investigation
		elsif !ca_investigation.nil?
			ca_investigation
		elsif !cr_investigation.nil?
			cr_investigation
		elsif !ja_investigation.nil?
			ja_investigation
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
