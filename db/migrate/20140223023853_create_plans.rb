class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :name
      t.decimal :amount
      t.string :interval

      t.timestamps
    end
  end
end
