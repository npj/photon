require 'sinatra/base'
require 'warden'
require 'slim'
require 'mongoid'
require 'dragonfly'
require 'rack/cache'
require 'aws/s3'

require_dir = proc do |dir| 
  Dir["./#{dir}/**/*.rb"].each do |f| 
    require f
  end
end

require_dir['lib']
require_dir['config']
require_dir['models']
require './photon/app'

module Photon
end
