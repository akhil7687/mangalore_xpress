class AddServiceProvidedToServiceCategory < ActiveRecord::Migration[5.0]
  def change
    add_column :service_categories, :service_provided_desc, :string, :limit => 10000
    add_column :service_categories, :service_provided, :string, :limit => 5000
  end
end
