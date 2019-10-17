require "sinatra"
require "sinatra/cookies"
require "sinatra/reloader" if development?
require "json"

require_relative "DB/user"
require_relative 'DB/list'
require_relative 'DB/itemList'


set :port, 9000
set :static_cache_control, [:public, max_age: 0]

enable :sessions

before do
    path_name = request.path_info
    if ['/', '/etiqueta'].include? path_name and not session[:username]
        redirect to("/acceso")
    end

    if ['/acceso', '/registro'].include? path_name and session[:username]
        redirect to("/")
    end

    if session[:username]
        @user = User.new.get(session[:username])
        @current_route = path_name
    end
end


get "/" do
    @Lists = List.new(session[:username]).getAll!
    erb :home, layout: :home_layout
end


post "/" do
    data = JSON.parse(request.body.read)

    data_title = data["title"]
    data_username = session[:username]
    data_items = Array.new

    data["items"].each do | item |
        content_item = item["content"]
        checked_item = item["checked"] ? 1 : 0

        item_list = ItemList.new(content: content_item, checked: checked_item)

        data_items.push(item_list)
    end

    List.new(
            data_username,
            title: data_title,
            items: data_items
    ).save!

    "Root path in post method"
end


get "/etiqueta" do
    erb :tag, layout: :home_layout
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

        @msg_success = "Usuario registrado correctamente"
    else
        @msg = "Error, las contraseñas no coinciden."
    end

    erb :register, layout: :main
end


get "/salir" do
    session.delete(:username)
    redirect "/"
end


configure :development do
    register Sinatra::Reloader
end