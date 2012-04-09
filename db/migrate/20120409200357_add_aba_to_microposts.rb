class AddAbaToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :aba, :boolean

  end
end
