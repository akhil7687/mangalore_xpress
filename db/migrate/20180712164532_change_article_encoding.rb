class ChangeArticleEncoding < ActiveRecord::Migration[5.0]
  def change
     # For the table that will store unicode execute:
    execute "ALTER TABLE feeds CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_bin"
    # For each column with unicode content execute:
    execute "ALTER TABLE feeds CHANGE details details TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_bin"
  end
end
