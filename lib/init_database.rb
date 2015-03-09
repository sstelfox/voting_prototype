
require 'dm-core'

require 'dm-constraints'
require 'dm-migrations'
require 'dm-timestamps'
require 'dm-transactions'
require 'dm-validations'

database_path = ENV['DATABASE_URL'] || 'sqlite://' + File.expand_path(File.join(File.dirname(__FILE__), '..', 'config', 'database.db'))

DataMapper::Logger.new($stdout, :info)
DataMapper.setup(:default, database_path)

Dir[File.join(File.dirname(__FILE__), '..', 'models', '*.rb')].each do |m|
  require "models/#{File.basename(m, '.rb')}"
end

DataMapper.finalize
