class AddColumnUserId < ActiveRecord::Migration[6.0]
  def change
    add_reference :schedules, :user, foreign_key: true
  end
end
