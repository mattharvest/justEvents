class AddDobAndAdfToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :dob, :date
    add_column :microposts, :adf, :string
  end
end
