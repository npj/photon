class Auth < Sinatra::Base

  get '/auth/login/?' do
    slim :'auth/login'
  end

  post '/auth/login/?' do
    env['warden'].authenticate!
    redirect '/'
  end

  delete '/auth/logout/?' do
    env['warden'].logout
  end
end
