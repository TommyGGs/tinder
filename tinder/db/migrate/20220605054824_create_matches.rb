class CreateMatches < ActiveRecord::Migration[6.1]
  def change
    create_table :matches do |t|
      t.references :user
      t.references :choosen_user
      t.timestamps null: false 
    end 
  end
end
