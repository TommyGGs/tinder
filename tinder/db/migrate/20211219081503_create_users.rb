class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :mail
      t.string :password_digest
      t.string :game 
      t.string :rank 
      t.string :gender 
      t.string :image_url
      t.string :name 
      t.string :profile
      t.integer :age 
      t.timestamps null: false 
    end 
  end
end
