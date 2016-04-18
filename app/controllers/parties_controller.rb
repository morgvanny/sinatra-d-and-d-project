class PartiesController < ApplicationController
  get '/parties' do
    @parties = Party.all
    erb :'/parties/index'
  end

  get '/parties/new' do
    @message = session[:message]
    session[:message] = nil
    if logged_in?
      @user = current_user
      if @user.characters.count >= 1
        erb :'/parties/create_party'
      else
        session[:message] = 'You have to have a character to start a party!'
        redirect to '/characters/new'
      end
    else
      session[:message] = 'You have to be logged in to create a party!'
      redirect '/login'
    end
  end

  get '/parties/:slug' do
    @message = session[:message]
    session[:message] = nil
    @party = Party.find_by_slug(params[:slug])
    erb :'parties/show_party'
  end

  get '/parties/:slug/join' do
    @party = Party.find_by_slug(params[:slug])
    if logged_in?
      @user = current_user
      if @user.characters.count >= 1
        @user.characters.each do |character|
          if character.party != @party
            return erb :'/parties/join_party'
          end
        end
        session[:message] = 'All of your characters are already in that party!'
        redirect to '/login'
      else
        session[:message] = 'You have to have a character to join a party!'
        redirect to '/characters/new'
      end
    else
      session[:message] = 'You have to be logged in to join a party!'
      redirect '/login'
    end
  end

  post '/parties' do
    if Party.find_by(name: params[:name])
      session[:message] = 'A party of that name already exists. Sorry!'
      redirect to '/parties/new'
    else
      @party = Party.create(name: params["name"])
      @character = Character.find_by_id(params["character"])
      @old_party = @character.party unless @character.party == nil
      @character.party = @party
      @character.save
      @add_message = ""
      if @old_party && @old_party.characters.empty?
        @old_party.delete
        @add_message = " Everyone left #{@old_party.name} (party) so it was deleted."
      end
      session[:message] = 'You successfully created a party!' + @add_message
      redirect to "parties/#{@party.slug}"
    end
  end

  post '/parties/:slug/join' do
    @party = Party.find_by_slug(params[:slug])
    @character = Character.find_by_id(params["character"])
    @old_party = @character.party unless @character.party == nil
    @character.party = @party
    @character.save
    @add_message = ""
    if @old_party && @old_party.characters.empty?
      @old_party.delete
      @add_message = " Everyone left #{@old_party.name} (party) so it was deleted."
    end
    session[:message] = "#{@character.name} successfully joined the party!" + @add_message
    redirect to "parties/#{@party.slug}"
  end

end
