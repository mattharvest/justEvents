class AddTeamleaderToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :teamleader, :string

  end
end
