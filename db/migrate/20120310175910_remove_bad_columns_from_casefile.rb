class RemoveBadColumnsFromCasefile < ActiveRecord::Migration
  def up
		remove_column :casefiles, :CCN
        remove_column :casefiles, :CR
        remove_column :casefiles, :CJ
        remove_column :casefiles, :CA
        remove_column :casefiles, :CT
        remove_column :casefiles, :SAO
        remove_column :casefiles, :JA
		add_column :casefiles, :ccn, :string
		add_column :casefiles, :cr, :string
		add_column :casefiles, :cj, :string
		add_column :casefiles, :ca, :string
		add_column :casefiles, :ct, :string
		add_column :casefiles, :sao, :string
		add_column :casefiles, :ja, :string
      end

  def down
    add_column :casefiles, :JA, :string
    add_column :casefiles, :SAO, :string
    add_column :casefiles, :CT, :string
    add_column :casefiles, :CA, :string
    add_column :casefiles, :CJ, :string
    add_column :casefiles, :CR, :string
    add_column :casefiles, :CCN, :string
		remove_column :casefiles, :ccn
		remove_column :casefiles, :cr
		remove_column :casefiles, :cj
		remove_column :casefiles, :ca
		remove_column :casefiles, :ct
		remove_column :casefiles, :sao
		remove_column :casefiles, :ja
  end
end
