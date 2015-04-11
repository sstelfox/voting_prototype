module Voting
  # Root of the prototype voting application.
  class App < Sinatra::Base
    enable :logging, :sessions, :method_override

    set :root, File.expand_path(File.join(File.dirname(__FILE__), '..'))
    set :views, (root + '/app/views')
    set :public_folder, (root + '/app/public')

    configure :development do
      enable :raise_errors
      enable :show_exceptions

      set :session_secret, 'Static Key'
    end

    use Rack::Flash
  end
end
