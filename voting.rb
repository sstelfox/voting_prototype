base_directory = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift(base_directory) unless $LOAD_PATH.include?(base_directory)

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

require 'app/helpers/auth_helpers'
require 'app/helpers/nested_model_helpers'
require 'app/helpers/post_helpers'

require 'lib/init_database'
require 'lib/voting_app'

require 'app/routes/default'
require 'app/routes/auth'
require 'app/routes/questions'
