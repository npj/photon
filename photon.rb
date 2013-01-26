require 'rubygems'
require 'bundler/setup'
Bundler.setup(:defaults, ENV['RACK_ENV'].to_sym)
require File.expand_path('../photon/app', __FILE__)

