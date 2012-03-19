class Addcolumnstomicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :gang, :string
	add_column :microposts, :jail, :string
	add_column :microposts, :probation, :string
	add_column :microposts, :restitution, :integer
	add_column :microposts, :communityservice, :integer
	add_column :microposts, :judge, :string
	add_column :microposts, :leadcharge, :string
	add_column :microposts, :convictedcharges, :string
	add_column :microposts, :enhanced, :boolean
	add_column :microposts, :guidelines, :string
  end
end
