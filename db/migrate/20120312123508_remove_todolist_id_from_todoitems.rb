class RemoveTodolistIdFromTodoitems < ActiveRecord::Migration
	def change
		remove_column :todoitems, :todolist_id
		add_column :todoitems, :casenumber, :string
	end
end
