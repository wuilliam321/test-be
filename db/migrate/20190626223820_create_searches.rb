class CreateSearches < ActiveRecord::Migration[5.2]
  def change
    create_table :searches do |t|
      t.decimal :lat
      t.decimal :lng
      t.text :cached_response

      t.timestamps
    end
  end
end
