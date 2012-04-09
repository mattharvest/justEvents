class RemoveGuidelinesFromMicroposts < ActiveRecord::Migration
	def change
		remove_column :microposts, :guidelines
		add_column :microposts, :guidelines_top, :integer
		add_column :microposts, :guidelines_bottom, :integer
	end
end
