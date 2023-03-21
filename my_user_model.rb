require 'sqlite3'

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

  def authenticate(email, password)
    puts "Email: #{email}"
    puts "Password: #{password}"
    user = @db.execute("SELECT * FROM users WHERE email = ? AND password = ?", [email, password]).first
    puts "User: #{user.inspect}"
    user
  end

  def update_password(id, new_password)
    @db.execute("UPDATE users SET password = ? WHERE id = ?", [new_password, id])
    find_user(id)
  end

  def delete_user(id)
    @db.execute("DELETE * FROM users WHERE id = ?", id)
  end
end



