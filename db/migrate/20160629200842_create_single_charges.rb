class CreateSingleCharges < ActiveRecord::Migration
  def change
    create_table :single_charges do |t|
      t.string :email
      t.string :stripe_token
      t.decimal :amount
      t.string :note

      t.timestamps
    end
  end
end
