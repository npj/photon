require 'sinatra/base'
require 'slim'

class Photon < Sinatra::Base
  set :sessions, true
  set :slim, :pretty => true

  get '/' do
    slim :'photon/index'
  end
end
