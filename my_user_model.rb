require 'active_record'

ActiveRecord::Base.establish_connection(
    adapter: 'sqlite3'
    database: 'my_database.sqlite3'
)

clase User < ActiveRecord::Base
    validates_presence_of :firstname, :lastname, :age, :password, :email
end
