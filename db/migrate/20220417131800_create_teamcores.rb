class CreateTeamcores < ActiveRecord::Migration[6.0]
  def change
    create_table :teamcores do |t|
      t.references :user, null: false, foreign_key: true
      t.text :teamname

      t.timestamps
    end
  end
end
