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

            @DB.execute("""
            create table if not exists Lists(
                id varchar(12) primary key not null,
                username varchar(25),
                create_date varchar(64) not null,
                update_date varchar(64) not null,
                foreign key (username) references Users(username)
                    on update set null
                    on delete set null
            )""")

            @DB.execute("""
            create table if not exists ItemList(
                id varchar(6) primary key not null,
                id_list varchar(12),
                content text,
                checked int default 0,
                foreign key (id_list) references Lists(id)
                    on update set null
                    on delete set null
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
            @DB.results_as_hash = true
            $results = @DB.get_first_row(cmd, *query_params)
        rescue SQLite3::Exception => e
            puts e
        ensure
            @DB.close
        end

        $results
    end
end