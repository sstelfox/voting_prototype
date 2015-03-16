module Voting
  module AuthHelpers
    # Get a copy of the currently logged in user or nil if the user is
    # invalid/not logged in.
    #
    # @return [User,Nil]
    def current_user
      Voting::User.get(session[:user])
    end

    # Checks to see whether or not the current user is logged in, also checks
    # to ensure the user is on the same network they logged in, just in case
    # that is missed somewhere it's an extra layer of protection.
    #
    # @return [Boolean]
    def logged_in?
      (!!current_user && session[:ip] == request.ip)
    end

    # A helper method that allows sinatra to become aware of when an action
    # requires a login before proceeding. Will ensure the user logs in before
    # they are able to continue.
    def login_required
      return false if logged_in?

      flash[:alert] = 'You need to login before continuing.'
      session[:stored_path] = request.fullpath if routeable_path?(request.fullpath)
      redirect '/login', 303
    end

    # A helper method to redirect to the last page requested that required a
    # login. Makes the work flow of logging in smoother as you don't have to
    # re-navigate back to the page you were on. Will default to the root home
    # page if there isn't a stored path.
    def redirect_to_stored
      if new_loc = session[:stored_path]
        session[:stored_path] = nil
        redirect new_loc
      else
        redirect '/'
      end
    end

    # Check to see whether or not the requested path is actually handled by
    # Sinatra. This is used to prevent us from redirecting a user to something
    # that isn't a sinatra route (such as a static asset or a 404 page)
    #
    # @param [String] path
    # @return [Boolean]
    def routeable_path?(path)
      valid_routes = self.class.routes.map do |verb, entries|
        ent = entries.map { |e| e[0] }
        if request.request_method == verb
          ent.map do |e|
            !!(e =~ path)
          end
        end
      end

      valid_routes.flatten.include?(true)
    end
  end
end
