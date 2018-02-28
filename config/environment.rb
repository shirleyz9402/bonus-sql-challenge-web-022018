require 'bundler'
Bundler.require
require 'csv'
require 'sqlite3'

DB => {:conn => SQLite3::Database.new("db/guests.db")}
