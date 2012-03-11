class AddDefendantToMicropost < ActiveRecord::Migration
  def change
    add_column :microposts, :defendant, :string

  end
end
