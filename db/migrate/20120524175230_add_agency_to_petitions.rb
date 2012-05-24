class AddAgencyToPetitions < ActiveRecord::Migration
  def change
    add_column :petitions, :agency, :string

  end
end
