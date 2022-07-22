class AddTeamhashid < ActiveRecord::Migration[6.0]
    def change
      add_column :teamcores, :access_token, :string
    end
end
