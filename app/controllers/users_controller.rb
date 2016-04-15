class UsersController < ApplicationController

  get '/signup' do
    if !logged_in?
      erb :'users/create_user'
    else
      redirect to "users/#{current_user.slug}"
    end
  end

  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    erb :'users/show'
  end

  get '/login' do
    if !logged_in?
      erb :'users/login'
    else
      redirect to "users/#{current_user.slug}"
    end
  end

  post '/signup' do
    if User.find_by(name: params[:name])
      erb :'/users/create_user', locals: {message: 'That username is taken already. Sorry!'}
    else
      @user = User.create(name: params[:name], password: params[:password])
      session[:user_id] = @user.id
      redirect to "users/#{current_user.slug}"
    end
  end

  post '/login' do
    user = User.find_by(name: params[:name])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect to "users/#{current_user.slug}"
    else
      redirect '/signup'
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
