class AddEmailAddressToPetitions < ActiveRecord::Migration
  def change
    add_column :petitions, :email_address, :string

  end
end
