# frozen_string_literal: true

class CreateBatteries < ActiveRecord::Migration[7.0]
  def change
    create_table :batteries do |t|
      t.integer :capacity

      t.timestamps
    end
  end
end
