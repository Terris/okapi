class AddVisibleToStudents < ActiveRecord::Migration
  def change
    add_column :students, :visible, :boolean, :default => true
  end
end
