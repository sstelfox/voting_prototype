class Voting::App
  get '/' do
    erb :'questions/index', :locals => { :questions => Voting::Question.all }
  end

  get '/diagnostics/?' do
    erb :diagnostics, :locals => {:diagnostics => params}
  end

  post '/diagnostics/?' do
    erb :diagnostics, :locals => {:diagnostics => params}
  end

  not_found do
    erb :'404'
  end

  error do
    erb :error
  end
end