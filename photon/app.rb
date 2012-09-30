require './photon/cache'
require './photon/http_methods'
require './photon/auth'
require './photon/processing'
require './photon/photos'
require './photon/albums'

module Photon
  class App < Sinatra::Base

    enable :logging

    set :slim, :pretty => true
    set :views, './views'

    register Cache
    register Processing
    register HttpMethods
    register Auth
    register Photos
    register Albums

    get '/' do
      env['warden'].authenticate!
      slim :'photon/index'
    end

    get '/upload' do
      env['warden'].authenticate!
      slim :'photon/upload'
    end
  end
end

