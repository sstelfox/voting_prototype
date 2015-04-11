module Voting
  class App
    helpers AuthHelpers

    set(:auth) do
      condition { login_required unless logged_in? }
    end

    get '/login/?' do
      if logged_in?
        flash[:notice] = 'You\'re already logged in.'
        redirect_to_stored
      else
        erb :'auth/login'
      end
    end

    post '/login/?' do
      if logged_in?
        flash[:notice] = 'You\'re already logged in.'
        redirect_to_stored
      end

      if (user = User.authenticate(params['username'], params['password']))
        session[:user] = user.id
        session[:ip] = request.ip
        flash[:success] = "You've successfully logged in as #{user.username}."

        redirect_to_stored
      else
        flash.now[:alert] = 'Invalid login credentials provided.'
        erb :'auth/login'
      end
    end

    # Logs the user out, this route isn't available unless the user is logged
    # in.
    get '/logout/?' do
      session[:user] = nil
      session[:ip] = nil

      flash[:notice] = 'You\'ve been logged out.'
      redirect '/'
    end

    error(403) do
      erb :'auth/forbidden'
    end
  end
end
