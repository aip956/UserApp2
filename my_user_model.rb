require 'active_record'
require 'sinatra/authentication'

ActiveRecord::Base.establish_connection(
    adapter: 'sqlite3',
    database: 'db.sql.sqlite3')

class User < ActiveRecord::Base
    self.table_name = 'users'
    validates_presence_of :firstname, :lastname, :age, :password, :email

    def self.authenticate(email, password)
        user = find_by(email: email)
        if user && user.password == password
          user
        else
          nil
        end
      end
end
