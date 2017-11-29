ENV['RACK_ENV'] ||= 'development'

# require './app/models/database_config'
require 'bcrypt'
require 'sinatra/base'
# require './app/models/peep.rb'
# require './app/models/user.rb'
require 'sinatra/flash'
require_relative 'dm_setup'

class Chitter < Sinatra::Base
  enable :sessions
  set :session_secret, 'super secret'
  register Sinatra::Flash

  helpers do
    def current_user
      @current_user ||= User.get(session[:user_id])
    end
  end

  get '/' do
    erb(:index)
  end

  post '/' do
    user = User.authenticate(params[:email], params[:password])
    if user
      session[:user_id] = user.id
    else
      flash.now[:errors] = ['The email or password is incorrect']
    end
    redirect '/'
  end

  get '/peeps' do
    @peeps = Peep.all
    erb(:peeps)
  end

  post '/peeps' do
    Peep.create(maker: current_user.username, body: params[:new_peep],
                user_id: current_user.id)
    redirect '/peeps'
  end

  get '/signup' do
    erb(:signup)

  end

  post '/signup' do
    user = User.new(name: params[:name],
                       email: params[:email],
                       username: params[:username],
                       password: params[:password],
                       password_confirmation: params[:password_confirmation])
    if user.save
      session[:user_id] = user.id
      redirect '/welcome'
    else
      flash.now[:notice] = "Password and confirmation password do not match"
      erb(:signup)
    end
  end

  get '/welcome' do
   erb(:welcome)
  end

  get '/msg' do
    erb(:msg)
  end

# Check if works without it
# run! if app_file == $0
end
