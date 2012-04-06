class AddUserIdToInvestigations < ActiveRecord::Migration
  def change
    add_column :investigations, :user_id, :integer

  end
end
