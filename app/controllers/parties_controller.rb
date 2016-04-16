class PartiesController < ApplicationController
  get '/parties' do
    @parties = Party.all
    erb :'/parties/index'
  end

  get '/parties/new' do
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
end
