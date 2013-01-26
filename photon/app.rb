require 'sinatra/base'
require 'slim'

module Photon

  def self.load(app)

    require "#{app.root}/../config/config"
    Config.load(app)

    %w{ lib models photon }.each do |sub|
      Dir["#{app.root}/../#{sub}/**/*.rb"].each { |f| require f }
    end
  end

  class App < Sinatra::Base

    Photon.load(self)

    set :slim, :pretty => true
    set :views, './views'

    register Cache
    register HttpMethods
    register Auth
    register Photos
    register Albums
    register Comments

    helpers do
      def can?(action, object)
        case object
          when Class
            case object.name
              when "Album"
                case action
                  when :create then true
                end
              when "Photo"
                case action
                  when :create then true
                end
            end

          when Album
            case action
              when :rename  then object.user == current_user
              when :upload  then object.user == current_user
              when :destroy then object.user == current_user
            end

          when Photo
            case action
              when :destroy then object.album.user == current_user
            end

          when Comment
            case action
              when :create then true
            end
        end
      end
    end

    get '/' do
      env['warden'].authenticate!
      slim :'photon/index'
    end

    get '/upload' do
      env['warden'].authenticate!
      slim :'photon/upload'
    end
  end
end

