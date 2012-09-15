require 'sinatra/base'
require 'warden'
require 'slim'

require './auth'
require './config/auth'

class Photon < Sinatra::Base

  enable :sessions

  set :slim, :pretty => true

  include Config::Auth

  get '/' do
    env['warden'].authenticate!
    slim :'photon/index'
  end
end
