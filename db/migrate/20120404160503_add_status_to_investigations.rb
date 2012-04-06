class AddStatusToInvestigations < ActiveRecord::Migration
  def change
    add_column :investigations, :status, :integer

  end
end
