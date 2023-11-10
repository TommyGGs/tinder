class CreateChats < ActiveRecord::Migration[6.1]
  def change
    create_table :chats do |t|
      t.references :user
      t.integer :sent_id
      t.string :text
      t.timestamps null: false 
    end
  end
end