class AddCompleteToTodoitem < ActiveRecord::Migration
  def change
    add_column :todoitems, :complete, :boolean

  end
end
