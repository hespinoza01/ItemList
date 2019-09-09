require "sinatra"
require "sinatra/cookies"
require "sinatra/reloader" if development?

require_relative "DB/user"


set :port, 9000

get "/" do
    unless session[:username]
        redirect to("/acceso")
    end

    erb :login, layout: :main
end

get "/acceso" do
    erb :login, layout: :main
end

post "/acceso" do
    if User.new.exists?(params[:username], params[:password])
        session[:username] = params[:username]
        redirect "/"
    end

    @msg = "usuario o contraseña incorrecto."
    erb :login, layout: :main
end


get "/registro" do
    erb :register, layout: :main
end

post "/registro" do
    u = User.new

    if params[:password] == params[:confirmPassword]
        u.username = params[:username]
        u.fullname = params[:fullname]
        u.password = params[:password]
        u.save!

        @msg = "Usuario registrado correctamente"
    else
        @msg = "Error, las contraseñas no coinciden."
    end

    erb :register, layout: :main
end


configure :development do
    register Sinatra::Reloader
end