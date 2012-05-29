class Petition < ActiveRecord::Base
	belongs_to :user
	
	attr_accessible :ccn, :asa, :asa_email, :defendant, :defendant_address, :defendant_dob, :school, :parent, :victim, :victim_address, :victim_adult_or_minor, :charges, :cpo_id, :cpo_name, :assisting_officers, :witnesses, :chemist, :pwid, :fingerprint, :examiner, :tech, :counterfeit, :expert_content, :corespondents, :incident_report, :statement_of_respondent, :statement_of_corespondents_etc, :victim_witness_list, :arrest_report, :investigation_report, :accident_report, :screening_apt, :statement_of_pc, :mitigation, :search_and_seizures, :respondent_statement_type, :respondent_statement, :witness_statement_type, :witness_statement, :premerits_id, :medical_records, :business_records, :police_records, :mva_records, :other_records, :other_description, :offense_date, :incident_address, :agency, :email_address
	
	attr_accessor :victim_age, :witness_statement_type_string, :respondent_statement_type_string
	
	validates :ccn, :presence=>true, :allow_blank=>false
	validates :asa, :presence=>true
	validates :asa_email, :presence=>true
	validates :defendant, :presence=>true
	validates :defendant_address, :presence=>true
	validates :victim, :presence=>true
	validates :victim_address, :presence=>true
	validates :charges, :presence=>true
	validates :statement_of_pc, :presence=>true
	validates :offense_date, :presence=>true
	validates :defendant_dob, :presence=>true
	validates :incident_address, :presence=>true, :allow_blank => true
	
	def defendant_statement_block
		tempstring=""
		case respondent_statement_type
			when 0
				tempstring="No statement. "
			when 1
				tempstring="Written statement: "
			when 2
				tempstring="Oral statement: "
		end
		
		tempstring+respondent_statement
	end
	
	def witness_statement_block
		tempstring=""
		case witness_statement_type
			when 0
				tempstring="No statement. "
			when 1
				tempstring="Written statement: "
			when 2
				tempstring="Oral statement: "
		end
		tempstring+witness_statement	
	end
	
	def expert?
		pwid | chemist | pwid | tech | fingerprint | counterfeit
	end
	
	def icon_letter?
		incident_report | statement_of_respondent | victim_witness_list | arrest_report | investigation_report | accident_report | screening_apt
	end
	
	def notices?
		medical_records | business_records | police_records | mva_records | other_records
	end
	
	def full_pc
		"On or about "+offense_date.to_s+", at "+incident_address+", Prince George's County, "+statement_of_pc
	end
end
