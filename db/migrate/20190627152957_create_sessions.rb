class CreateSessions < ActiveRecord::Migration[5.2]
  def change
    create_table :sessions do |t|
      t.text :email, null: false
      t.text :remote_token
      t.text :token
      t.text :user_info

      t.timestamps
    end
  end
end
