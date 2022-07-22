class Addteam < ActiveRecord::Migration[6.0]
  def change
    add_reference :schedules, :teamcore, foreign_key: true

  end
end
