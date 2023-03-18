require 'active_record'
require 'sinatra'
require 'sqlite3'


class User < ActiveRecord::Base
    db =SQLite3::Database.open("db.sql")
    db.execute("
      CREATE TABLE [IF NOT EXISTS] User (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        firstname TEXT NOT NULL,
        lastname TEXT NOT NULL,
        age INTEGER,
        password TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP
      ); 
    ")
    db.execute("SELECT * FROM users")


  #self.table_name = 'users'
  #  validates_presence_of :firstname, :lastname, :age, :password, :email
  if 
    def self.authenticate(email, password)
        user = find_by(email: email)
        if user && user.password == password
          user
        else
          nil
        end
    end
  end

end
