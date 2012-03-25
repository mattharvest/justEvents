class AddOffendertypeToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :offendertype, :string

  end
end
