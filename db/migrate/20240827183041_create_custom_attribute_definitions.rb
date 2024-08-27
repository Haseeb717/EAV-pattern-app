class CreateCustomAttributeDefinitions < ActiveRecord::Migration[7.0]
  def change
    create_table :custom_attribute_definitions do |t|
      t.string :model_type
      t.string :key

      t.timestamps
    end
  end
end
