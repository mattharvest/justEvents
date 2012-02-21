class AddCharacteristicsToMicropost < ActiveRecord::Migration
  def change
    add_column :microposts, :unit, :string
    add_column :microposts, :event_date, :date
    add_column :microposts, :category, :string
    add_column :microposts, :casenumber, :string
  end
end
