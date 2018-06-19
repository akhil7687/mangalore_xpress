class AddContactNumberToClassifieds < ActiveRecord::Migration[5.0]
  def change
    add_column :classifieds, :phone, :string
  end
end
