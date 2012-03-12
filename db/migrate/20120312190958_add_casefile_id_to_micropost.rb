class AddCasefileIdToMicropost < ActiveRecord::Migration
  def change
	add_column :microposts, :casefile_id, :integer
  end
end
