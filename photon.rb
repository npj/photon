require 'sinatra/base'
require 'warden'
require 'slim'
require 'mongoid'

%w{ config models }.each do |dir|
  Dir["./#{dir}/**/*.rb"].each { |f| require f }
end

require './auth'

class Photon < Sinatra::Base

  enable :logging

  set :slim, :pretty => true

  register Sinatra::Auth

  get '/' do
    env['warden'].authenticate!
    slim :'photon/index'
  end
end
