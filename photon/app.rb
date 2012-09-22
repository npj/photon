require './photon/cache'
require './photon/http_methods'
require './photon/auth'
require './photon/processing'
require './photon/photos'

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

    get '/' do
      env['warden'].authenticate!
      slim :'photon/index'
    end
  end
end

