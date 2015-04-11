
base_path = File.expand_path(File.join(File.dirname(__FILE__), '..'))
database_path = ENV['DATABASE_URL'] ||
                ENV['HEROKU_POSTGRESQL_JADE_URL'] ||
                'sqlite://' + File.join(base_path, 'config', 'database.db')

DataMapper::Logger.new($stdout, :info)
DataMapper.setup(:default, database_path)

require 'app/models/answer'
require 'app/models/question'
require 'app/models/user'
require 'app/models/va'
require 'app/models/voter'

DataMapper.finalize
