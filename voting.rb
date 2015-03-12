base_directory = File.expand_path(File.dirname(__FILE__))
$:.unshift(base_directory) unless $:.include?(base_directory)

require 'rubygems'
require 'json'

require 'dm-core'

require 'dm-aggregates'
require 'dm-constraints'
require 'dm-migrations'
require 'dm-timestamps'
require 'dm-transactions'
require 'dm-validations'

require 'sinatra/base'
require 'sinatra/namespace'
require 'rack-flash'

require 'lib/core_ext/hash'
require 'lib/init_database'

require 'lib/voting_app'
require 'app/routes/default'
require 'app/routes/auth'
require 'app/routes/questions'
