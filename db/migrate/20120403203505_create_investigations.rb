class CreateInvestigations < ActiveRecord::Migration
  def change
    create_table :investigations do |t|
      t.string :unit
      t.integer :assignee_id
      t.integer :assignor
      t.string :defendant
      t.date :arrest_date
      t.string :casenumber
      t.date :initial_appearance
      t.date :preliminary_hearing
      t.date :district_date
      t.string :district_room
      t.string :victim
      t.date :incident_date
      t.string :address
      t.text :synopsis

      t.timestamps
    end
  end
end
