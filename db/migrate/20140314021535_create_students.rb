class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.references :user, index: true

      t.timestamps
    end
  end
end
