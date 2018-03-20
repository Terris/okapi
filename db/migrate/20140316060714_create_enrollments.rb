class CreateEnrollments < ActiveRecord::Migration
  def change
    create_table :enrollments do |t|
      t.references :roster, index: true
      t.references :student, index: true

      t.timestamps
    end
  end
end
