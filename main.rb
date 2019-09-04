require "sinatra"
require "sinatra/cookies"
require "sinatra/reloader" if development?

set :port, 9000

get "/" do
    unless session[:username]
        redirect to("/login")
    end

    erb :login, layout: :main
end

get "/acceso" do
    erb :login, layout: :main
end

get "/registro" do
    erb :register, layout: :main
end


configure :development do
    register Sinatra::Reloader
end