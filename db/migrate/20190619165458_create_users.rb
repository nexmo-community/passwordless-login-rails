class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :msisdn

      t.timestamps

      t.index [ :msisdn ], unique: true
    end

    
  end
end
