require 'base64'
require_relative 'sqliteDB'

class User < SqliteDB
    attr_accessor :username
    attr_accessor :fullname

    def initialize
        super()
        @username= "default username"
        @fullname= "default name"
        @password= "default password"
    end

    def password=(value)
        @password = Base64.encode64(value)
    end

    def password
        Base64.decode64(@password)
    end

    def save!
        execute("insert into Users(username, fullname, password) values(?, ?, ?)", @username, @fullname, @password)
    end

    def update!
        execute("update Users set username=?, fullname=?, password=? where username=? ", @username, @fullname, @password, @username)
    end
end