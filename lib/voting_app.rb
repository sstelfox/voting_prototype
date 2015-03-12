module Voting
  class App < Sinatra::Base
    enable :logging, :sessions, :method_override

    set :root, File.expand_path(File.dirname(__FILE__))
    set :views, (self.root + '/views')
    set :public_folder, (self.root + '/public')

    configure :development do
      enable :raise_errors
      enable :show_exceptions
    end

    use Rack::Flash
  end
end
