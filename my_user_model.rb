require 'active_record'

ActiveRecord::Base.establish_connection(
    adapter: 'sqlite3',
    database: 'db.sql.sqlite3')

class User < ActiveRecord::Base
    self.table_name = 'users'
    validates_presence_of :firstname, :lastname, :age, :password, :email
end
