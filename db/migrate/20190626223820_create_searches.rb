class CreateSearches < ActiveRecord::Migration[5.2]
  def change
    create_table :searches do |t|
      t.text :lat, null: false
      t.text :lng, null: false
      t.integer :country, null: false
      t.text :cached_response
      t.belongs_to :session, foreign_key: true

      t.timestamps
    end
  end
end
