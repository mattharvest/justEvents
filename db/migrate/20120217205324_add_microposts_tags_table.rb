class AddMicropostsTagsTable < ActiveRecord::Migration
	def change
		create_table :microposts_tags, :id => false do |t|
			t.integer 	:micropost_id
			t.integer	:tag_id
		end
	end
end
