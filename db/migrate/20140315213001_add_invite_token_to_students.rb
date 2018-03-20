class AddInviteTokenToStudents < ActiveRecord::Migration
  def change
    add_column :students, :invite_token, :string
  end
end
