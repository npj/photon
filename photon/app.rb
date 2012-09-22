require './photon/auth'
require './photon/http_methods'
require './photon/processing'
require './photon/photos'

module Photon
  class App < Sinatra::Base

    enable :logging

    set :slim, :pretty => true
    set :views, './views'

    use HttpMethods
    register Auth
    register Processing
    register Photos

    get '/' do
      env['warden'].authenticate!
      slim :'photon/index'
    end
  end
end

