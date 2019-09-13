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

    def exists?(_username, _password)
        result = get_first("select * from Users where username=? and password=?", [_username, Base64.encode64(_password)])
        (result) ? true : false
    end

    def get(_username)
        result = User.new

        row = get_first("select username, fullname from Users where username=?", _username)

        result.username= row[0]
        result.fullname= row[1]

        result
    end
end