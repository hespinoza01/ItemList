require 'date'
require_relative 'sqliteDB'

require_relative 'itemList'
require_relative '../Utilities/current_datetime'
require_relative '../Utilities/../Utilities/random_string'

class List < SqliteDB
    attr_accessor :username, :id, :create_date, :update_date, :items

    include CurrentDateTime
    include RandomString

    def initialize(_username=nil)
        super()
        @create_date = getCurrentDateTime
        @update_date = @create_date
        @id = getRandomString
        @username = _username
        @items = Array.new
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
        result.items.push(*ItemList.new(id_list:result.id).getItemsList!)

        result
    end

    def getAll!
        results = Array.new

        rows = query("select id from Lists")

        rows.each do |row|
            results << get(row.first)
        end

        results
    end

    def to_s
        puts "ID: #{id}"
        puts "USERNAME: #{username}"
        puts "CREATE DATE: #{create_date}"
        puts "UPDATE DATE: #{update_date}"
        puts "ITEMS #{items.length}: "
        items.each do |i|
            puts "    #{i}"
        end
    end
end