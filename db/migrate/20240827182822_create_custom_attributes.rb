# frozen_string_literal: true

class CreateCustomAttributes < ActiveRecord::Migration[7.0]
  def change
    create_table :custom_attributes do |t|
      t.references :customizable, polymorphic: true, null: false
      t.string :key
      t.string :value

      t.timestamps
    end

    add_index :custom_attributes,
              %i[customizable_type customizable_id key], unique: true,
                                                         name: 'index_custom_attributes_on_type_and_id_and_key'
  end
end
