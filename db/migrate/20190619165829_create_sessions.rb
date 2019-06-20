class CreateSessions < ActiveRecord::Migration[6.0]
  def change
    create_table :sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :pin
      t.string :session_token
      t.boolean :is_active
      t.datetime :last_used_at
      
      t.timestamps
    end
  end
end
