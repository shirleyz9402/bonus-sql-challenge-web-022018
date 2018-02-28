require 'csv'
require 'sqlite3'
DB = {:conn => SQLite3::Database.new("db/guests.db")}
class Guest
  attr_accessor :year, :job, :day, :career, :name
  attr_reader :id
def initialize(year, job, day, career, name, id = nil)
  @year = year
  @job = job
  @date = day
  @career = career
  @name = name
  @id = id
end

def self.import
  file_path = "./daily_show_guests.csv"
  guests = []
  CSV.foreach(file_path) {|row| guests << row}
  guests.each do |guest|
    Guest.create(guest[0],guest[1],guest[2],guest[3],guest[4])
  end
end

def self.create(year, job, day, career, name)
  guest = Guest.new(year, job, day, career, name)
  guest.save
  guest
end

def self.create_table
  sql = <<-SQL
    CREATE TABLE IF NOT EXISTS guests (
      id INTEGER PRIMARY KEY,
      year INTEGER,
      job TEXT,
      day DATETIME,
      career TEXT,
      name TEXT
    )
    SQL
    DB[:conn].execute(sql)
    self.import
  end

  def save
    sql = <<-SQL
    INSERT INTO guests (year, job, day, career, name)
    VALUES (?,?,?,?,?)
    SQL
    DB[:conn].execute(sql, self.year, self.job, self.day, self.career,self.name )
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM guests")[0][0]
  end
end
Guest.create_table
Guest.import
