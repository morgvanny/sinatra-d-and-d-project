class CharactersController < ApplicationController

  get '/characters/new' do
    if logged_in?
      @user = current_user
      @message = session[:message]
      session[:message] = nil
      erb :'/characters/create_character'
    else
      session[:message] = 'You have to be logged in to create a character!'
      redirect to '/login'
    end
  end

  get '/characters/:id' do
    @message = session[:message]
    session[:message] = nil
    @character = Character.find_by_id(params[:id])
    erb :'characters/show_character'
  end

  get '/characters/:id/edit' do
    @character = Character.find_by_id(params[:id])
    if current_user.id == @character.user_id
      erb :'/characters/edit_character'
    else
      session[:message] = 'You can\'t edit someone else\'s character!'
      redirect to '/login'
    end
  end

  post '/characters' do
    @character = Character.create(name: params["name"], race: params["race"], character_class: params["character_class"],
      alignment: params["alignment"], strength: params["strength"], dexterity: params["dexterity"], constitution: params["constitution"],
      intelligence: params["intelligence"], wisdom: params["wisdom"], charisma: params["charisma"], hp: params["hit points"],
      ac: params["armor class"], initiative: params["initiative"], speed: params["speed"], notes: params["notes"])
    @character.party = Party.find_by(name: params["party"])
    @character.user = current_user
    @character.save
    session[:message] = 'You successfully created a character!'
    redirect to "/characters/#{@character.id}"
  end

  patch '/characters/:id' do
    @character = Character.find_by_id(params[:id])
    @character.update(name: params["name"], race: params["race"], character_class: params["character_class"],
      alignment: params["alignment"], strength: params["strength"], dexterity: params["dexterity"], constitution: params["constitution"],
      intelligence: params["intelligence"], wisdom: params["wisdom"], charisma: params["charisma"], hp: params["hit points"],
      ac: params["armor class"], initiative: params["initiative"], speed: params["speed"], notes: params["notes"])
    @old_party = @character.party
    @character.party = Party.find_by(name: params["party"])
    @character.save
    @add_message = ""
    if @old_party && @old_party.characters.empty?
      @add_message = " Everyone left #{@old_party.name} (party) so it was deleted."
      @old_party.delete
    end
    session[:message] = 'You successfully updated your character!' + @add_message
    redirect to "/characters/#{@character.id}"
  end

  delete '/characters/:id/delete' do
    @character = Character.find_by_id(params[:id])
    @add_message = ""
    if current_user.id == @character.user_id
      @party = @character.party
      name = @character.name
      @character.delete
      if @party && @party.characters.empty?
        @add_message = " Everyone left #{@party.name} (party) so it was deleted."
        @party.delete
      end
      session[:message] = "#{name} is no more!" + @add_message
      redirect to '/login'
    else
      session[:message] = 'You can\'t delete someone else\'s character!'
      redirect to '/login'
    end
  end

end
