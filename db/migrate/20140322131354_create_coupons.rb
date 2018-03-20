class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.string :name
      t.decimal :amount_off
      t.text :notes

      t.timestamps
    end
  end
end
