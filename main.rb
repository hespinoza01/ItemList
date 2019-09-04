require "sinatra"
require "sinatra/reloader" if development?

set :port, 9000

get "/" do
  "Connected"
end


configure :development do
  register Sinatra::Reloader
end