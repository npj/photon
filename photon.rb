require 'sinatra/base'
require 'warden'
require 'slim'
require 'mongoid'

%w{ config models }.each do |dir|
  Dir["./#{dir}/**/*.rb"].each { |f| require f }
end

require './photon/app'

module Photon
end
