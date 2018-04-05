require 'spec_helper'




describe 'character show page' do
  context 'logged in' do
    it 'shows edit button if logged in' do
      user = User.create(:name => "name", :password => "password")
      character = Character.create(:name => "name", :race => "race", :character_class => "character_class", :alignment => "name" ,:strength => "name" ,:dexterity => "name",:constitution => "name", :intelligence => "name", :wisdom => "name", :charisma => "name", :ac => "name", :initiative => "name", :speed => "name")
      character.user_id = user.id
      character.save
      session = {}
      session[:user_id] = user.id
      visit "/characters/#{character.id}"

      expect(page.body).to include("Edit Character")
    end
  end
end
