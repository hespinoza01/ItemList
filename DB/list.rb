require 'date'
require 'sqliteDB'

require_relative '../Utilities/current_datetime'
require_relative '../Utilities/../Utilities/random_string'

class List < SqliteDB
    attr_accessor :username, :id, :create_date, :update_date

    include CurrentDateTime
    include RandomString

    def initialize()
        super()
        @create_date = getCurrentDateTime
        @update_date = @create_date
        @id = getRandomString
    end

    def save!
        params = [id, username, create_date, update_date]
        execute("insert into Lists(id, username, create_date, update_date) values(?, ?, ?, ?)", *params)
    end

    def update!
        params = [username, create_date, getCurrentDateTime, id]
        execute("update Lists set username=?, create_date=?, update_date=? where id=?", *params)
    end

    def get(_id)
        result = List.new

        row = get_first("select id, username, create_date, update_date from Lists where id=?", _id)

        result.id = row[0]
        result.username = row[1]
        result.create_date = row[2]
        result.update_date = row[3]

        result
    end
end