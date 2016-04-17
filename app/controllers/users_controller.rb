class UsersController < ApplicationController

  get '/signup' do
    @message = session[:message]
    session[:message] = nil
    if !logged_in?
      erb :'users/create_user'
    else
      redirect to "/users/#{current_user.slug}"
    end
  end

  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    @message = session[:message]
    session[:message] = nil
    if logged_in? && current_user.id == @user.id
      erb :'users/personal_profile'
    else
      erb :'users/show'
    end
  end

  get '/login' do
    if !logged_in?
      @message = session[:message]
      session[:message] = nil
      erb :'users/login'
    else
      redirect to "/users/#{current_user.slug}"
    end
  end

  post '/signup' do
    if User.find_by(name: params[:name])
      session[:message] = 'That username is taken already. Sorry!'
      redirect to '/users/signup'
    else
      @user = User.create(name: params[:name], password: params[:password])
      session[:user_id] = @user.id
      redirect to "/users/#{current_user.slug}"
    end
  end

  post '/login' do
    user = User.find_by(name: params[:name])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect to "/users/#{current_user.slug}"
    elsif !user
      session[:message] = 'That user doesn\'t exist. You can create it here!'
      redirect '/signup'
    else
      session[:message] = 'Wrong password. Try that again!'
      redirect to '/login'
    end
  end

  get '/logout' do
    if session[:user_id] != nil
      session.destroy
      redirect to '/login'
    else
      redirect to '/'
    end
  end

end
