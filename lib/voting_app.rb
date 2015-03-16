module Voting
  class App < Sinatra::Base
    enable :logging, :sessions, :method_override

    set :root, File.expand_path(File.join(File.dirname(__FILE__), '..'))
    set :views, (self.root + '/app/views')
    set :public_folder, (self.root + '/app/public')

    configure :development do
      enable :raise_errors
      enable :show_exceptions

      set :session_secret, 'Static Key'
    end

    use Rack::Flash
  end
end
