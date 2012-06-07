class AddDuedatesToPetitions < ActiveRecord::Migration
  def change
    add_column :petitions, :soft_due_date, :date
    add_column :petitions, :hard_due_date, :date

  end
end
