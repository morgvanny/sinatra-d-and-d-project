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

  post '/characters' do
    @character = Character.create(name: params["name"])
    @character.party = Party.find_by(name: params["party"])
    @character.user = current_user
    @character.save
    session[:message] = 'You successfully created a character!'
    binding.pry
    redirect to "characters/#{@character.id}"
  end




end
