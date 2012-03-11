class CreateCasefiles < ActiveRecord::Migration
  def change
    create_table :casefiles do |t|
      t.string :CCN
      t.string :CR
      t.string :CT
      t.string :CJ
      t.string :CA
      t.string :SAO
      t.string :defendant

      t.timestamps
    end
  end
end
