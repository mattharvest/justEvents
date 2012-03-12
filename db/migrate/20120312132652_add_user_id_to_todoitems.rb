class AddUserIdToTodoitems < ActiveRecord::Migration
  def change
    add_column :todoitems, :user_id, :integer

  end
end
