require './photon/auth'
require './photon/http_methods'

module Photon
  class App < Sinatra::Base

    enable :logging

    set :slim, :pretty => true
    set :views, './views'

    use HttpMethods
    register Auth

    get '/' do
      env['warden'].authenticate!
      slim :'photon/index'
    end
  end
end

