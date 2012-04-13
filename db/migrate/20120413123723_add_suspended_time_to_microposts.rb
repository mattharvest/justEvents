class AddSuspendedTimeToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :suspended_time, :integer
	change_column :microposts, :jail, :integer
  end
end
