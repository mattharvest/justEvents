class CreateTodoitems < ActiveRecord::Migration
  def change
    create_table :todoitems do |t|
		t.string :content
		t.integer :todolist_id
		t.date :duedate
		t.integer :priority

      t.timestamps
    end
	add_index :todoitems, [:todolist_id, :created_at]
  end
end
