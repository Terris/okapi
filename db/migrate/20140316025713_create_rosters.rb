class CreateRosters < ActiveRecord::Migration
  def change
    create_table :rosters do |t|
      t.string :class_name
      t.date :start_date
      t.date :end_date
      
      t.timestamps
    end
  end
end
