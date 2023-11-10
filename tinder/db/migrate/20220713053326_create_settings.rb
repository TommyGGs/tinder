class CreateSettings < ActiveRecord::Migration[6.1]
  def change
    create_table :settings do |t|
      t.string :game
      t.string :gender
      t.references :user 
      t.timestamps null: false 
    end
  end
end
