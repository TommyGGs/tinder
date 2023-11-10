class CreateWatchings < ActiveRecord::Migration[6.1]
  def change
    create_table :watchings do |t|
      t.integer :watching_id, default: 1
      t.references :user 
      t.timestamps null: false 
    end 
  end
end
