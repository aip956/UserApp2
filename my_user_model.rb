require 'sqlite3'

# ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db.sql')

class User 
  def initialize
    @db =SQLite3::Database.open("db.sql")
    @db.results_as_hash = true
    @db.execute("
      CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        firstname TEXT NOT NULL,
        lastname TEXT NOT NULL,
        age INTEGER,
        password TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP
      ); 
    ")
  end

  def all_users
    @db.execute("SELECT * FROM users")
  end

  def add_user(firstname, lastname, age, password, email)
    @db.execute("INSERT INTO users(firstname, lastname, age, password, email) VALUES(?, ?, ?, ?, ?)",
    firstname, lastname, age, password, email)
  end

  def find_user(id)
    @db.execute("SELECT * FROM users WHERE id = ?", id).first
  end

  def delete_user(id)
    @db.execute("DELET * FROM users WHERE id = ?", id)
  end
end


  #self.table_name = 'users'
# validates_presence_of :firstname, :lastname, :age, :password, :email

    # def self.authenticate(email, password)
    #     user = find_by(email: email)
    #     if user && user.password == password
    #       user
    #     else
    #       nil
    #     end
    # end

# end
