class CreateCharacters < ActiveRecord::Migration
  def change
    create_table :characters do |t|
      t.string :name
      t.integer :user_id
      t.integer :party_id
    end
  end
end
