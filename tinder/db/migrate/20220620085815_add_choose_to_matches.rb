class AddChooseToMatches < ActiveRecord::Migration[6.1]
  def change
    add_column :matches, :choose, :boolean
  end
end
