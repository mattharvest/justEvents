class Petition < ActiveRecord::Base
	attr_accessible :ccn, :asa, :asa_email, :defendant, :defendant_address, :defendant_dob, :school, :parent, :victim, :victim_address, :victim_adult_or_minor, :charges, :cpo_id, :cpo_name, :assisting_officers, :witnesses, :chemist, :pwid, :fingerprint, :examiner, :tech, :counterfeit, :expert_content, :corespondents, :incident_report, :statement_of_respondent, :statement_of_corespondents_etc, :victim_witness_list, :arrest_report, :investigation_report, :accident_report, :screening_apt, :statement_of_pc, :mitigation, :search_and_seizures, :respondent_statement_type, :respondent_statement, :witness_statement_type, :witness_statement, :premerits_id, :medical_records, :business_records, :police_records, :mva_records, :other_records, :other_description, :offense_date, :incident_address
	
	attr_accessor :victim_age, :witness_statement_type_string, :respondent_statement_type_string
	
	validates :ccn, :presence=>true, :allow_blank=>false
	validates :asa, :presence=>true
	validates :asa_email, :presence=>true
	validates :defendant, :presence=>true
	validates :defendant_address, :presence=>true
	validates :defendant_dob, :presence=>true
	validates :school, :presence=>true, :allow_blank => true
	validates :parent, :presence=>true, :allow_blank => true
	validates :victim, :presence=>true
	validates :victim_address, :presence=>true
	validates :victim_adult_or_minor, :presence=>true
	validates :charges, :presence=>true
	validates :cpo_id, :presence=>true, :allow_blank => true
	validates :cpo_name, :presence=>true, :allow_blank => true
	validates :assisting_officers, :presence=>true, :allow_blank => true
	validates :witnesses, :presence=>true, :allow_blank => true
	validates :corespondents, :presence=>true, :allow_blank => true
	validates :statement_of_pc, :presence=>true
	validates :mitigation, :presence=>true, :allow_blank => true
	validates :search_and_seizures, :presence=>true, :allow_blank => true
	validates :respondent_statement_type, :presence=>true
	validates :respondent_statement, :presence=>true, :allow_blank => true
	validates :witness_statement_type, :presence=>true
	validates :witness_statement, :presence=>true, :allow_blank => true
	validates :premerits_id, :presence=>true, :allow_blank => true
	validates :offense_date, :presence=>true
	validates :incident_address, :presence=>true, :allow_blank => true
	
end
