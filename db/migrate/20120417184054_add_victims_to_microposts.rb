class AddVictimsToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :victims, :integer

  end
end
