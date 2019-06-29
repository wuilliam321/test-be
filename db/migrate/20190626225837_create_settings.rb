class CreateSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :settings do |t|
      t.text :key, null: false
      t.text :value, null: false

      t.timestamps
    end
  end
end
