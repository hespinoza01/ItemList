require_relative 'sqliteDB'
require_relative '../Utilities/random_string'

class ItemList < SqliteDB
    attr_accessor :id, :id_list, :content, :checked

    include RandomString

    def initialize(id:nil, id_list:nil, content:nil, checked:nil)
        super()

        @id_list = id_list
        @content = content
        @checked = checked
    end

    def to_s
        "#{id} - #{id_list} - #{content} - #{checked}"
    end

    def getItemsList!
        result = Array.new

        rows = query('select * from ItemList where id_list=?', id_list)

        rows.each do |row|
            item = ItemList.new

            item.id = row[0]
            item.id_list = row[1]
            item.content = row[2]
            item.checked = row[3]

            result << item
        end

        result
    end

    def save!
        params = [getRandomString(6), id_list, content]
        execute("insert into ItemList(id, id_list, content) values(?, ?, ?)", *params)
    end

    def update!
        params = [id_list, content, checked, id]
        execute("update ItemList set id_list=?, content=?, checked=? where id=?", *params)
    end
end