require "sqlite3"

class SqliteDB
    attr_reader :uriDB

    def initialize
        @uriDB = 'itemlist.db'

        begin
            @DB = SQLite3::Database.open(uriDB)
            @DB.results_as_hash = true

            @DB.execute("""
            create table if not exists Users(
                username varchar(25) primary key not null,
                fullname varchar(255) not null,
                password varchar(64) not null
            )""")
        rescue SQLite3::Exception => e
            puts e
        ensure
            @DB.close
        end
    end

    def execute(query, *query_params)
        begin
            @DB = SQLite3::Database.open(uriDB)
            @DB.execute(query, *query_params)
        rescue SQLite3::Exception => e
            puts e
        ensure
            @DB.close
        end
    end

    def query(cmd, *query_params)
        $results = nil

        begin
            @DB = SQLite3::Database.open(uriDB)
            $results = @DB.execute(cmd, *query_params)
        rescue SQLite3::Exception => e
            puts e
        ensure
            @DB.close
        end

        $results
    end

    def get_first(cmd, *query_params)
        $results = nil

        begin
            @DB = SQLite3::Database.open(uriDB)
            $results = @DB.get_first_row(cmd, *query_params)
        rescue SQLite3::Exception => e
            puts e
        ensure
            @DB.close
        end

        $results
    end
end