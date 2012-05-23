class CreatePetitions < ActiveRecord::Migration
  def change
    create_table :petitions do |t|
		t.string 	:ccn
		t.string 	:asa
		t.string	:asa_email
		t.string 	:defendant
		t.string 	:defendant_address
		t.date 		:defendant_dob
		t.string	:school
		t.string 	:parent
		t.string	:victim
		t.string	:victim_address
		t.boolean	:victim_adult_or_minor
		t.text		:charges
		t.string	:cpo_id
		t.string	:cpo_name
		t.string		:assisting_officers
		t.text		:witnesses
		t.boolean	:chemist
		t.boolean	:pwid
		t.boolean	:fingerprint
		t.boolean	:examiner
		t.boolean	:tech
		t.boolean	:counterfeit
		t.string		:expert_content
		t.string	:corespondents
		t.boolean	:incident_report
		t.boolean	:statement_of_respondent
		t.boolean	:statement_of_corespondents_etc
		t.boolean	:victim_witness_list
		t.boolean	:arrest_report
		t.boolean	:investigation_report
		t.boolean	:accident_report
		t.boolean	:screening_apt
		t.text		:statement_of_pc
		t.string	:incident_address
		t.string		:mitigation
		t.string		:search_and_seizures
		t.integer	:respondent_statement_type
		t.string	:respondent_statement
		t.integer	:witness_statement_type
		t.string	:witness_statement
		t.string	:premerits_id
		t.boolean	:medical_records
		t.boolean	:business_records
		t.boolean	:police_records
		t.boolean	:mva_records
		t.boolean	:other_records
		t.string	:other_description
		t.date		:offense_date

      t.timestamps
    end
  end
end
