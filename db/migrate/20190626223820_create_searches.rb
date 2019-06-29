class CreateSearches < ActiveRecord::Migration[5.2]
  def change
    create_table :searches do |t|
      t.text :lat
      t.text :lng
      t.integer :country
      t.text :cached_response
      t.belongs_to :session, foreign_key: true

      t.timestamps
    end
  end
end
