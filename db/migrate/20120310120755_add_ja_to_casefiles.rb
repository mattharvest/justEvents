class AddJaToCasefiles < ActiveRecord::Migration
  def change
    add_column :casefiles, :JA, :string

  end
end
