require './photon/auth'

module Photon
  class App < Sinatra::Base

    enable :logging

    set :slim, :pretty => true
    set :views, './views'

    register Auth

    get '/' do
      env['warden'].authenticate!
      slim :'photon/index'
    end
  end
end

