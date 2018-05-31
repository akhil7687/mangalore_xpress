class AddIsAdminToUserTokens < ActiveRecord::Migration[5.0]
  def change
    add_column :user_tokens, :is_admin, :integer,:default=>0
    add_column :user_tokens, :subscribe, :integer,:default=>1
  end
end
