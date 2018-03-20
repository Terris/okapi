class AddInvitesSentToStudents < ActiveRecord::Migration
  def change
    add_column :students, :invites_sent, :integer
  end
end
