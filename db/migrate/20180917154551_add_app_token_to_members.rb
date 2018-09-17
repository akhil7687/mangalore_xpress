class AddAppTokenToMembers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :app_token, :string
  end
end
