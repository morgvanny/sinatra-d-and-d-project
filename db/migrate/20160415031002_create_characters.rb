class CreateCharacters < ActiveRecord::Migration
  def change
    create_table :characters do |t|
      t.string :name
      t.string :race
      t.string :character_class
      t.string :alignment
      t.integer :strength
      t.integer :dexterity
      t.integer :constitution
      t.integer :intelligence
      t.integer :wisdom
      t.integer :charisma
      t.integer :hp
      t.integer :ac
      t.integer :initiative
      t.integer :speed
      t.string :notes
      t.integer :user_id
      t.integer :party_id
    end
  end
end
