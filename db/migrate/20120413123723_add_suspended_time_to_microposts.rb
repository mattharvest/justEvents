class AddSuspendedTimeToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :suspended_time, :integer

  end
end
