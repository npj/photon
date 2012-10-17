require './photon/cache'
require './photon/http_methods'
require './photon/auth'
require './photon/processing'
require './photon/photos'
require './photon/albums'

module Photon
  class App < Sinatra::Base

    set :slim, :pretty => true
    set :views, './views'

    register Cache
    register Processing
    register HttpMethods
    register Auth
    register Photos
    register Albums

    set :log_file, File.join(File.dirname(root), "log", "#{environment}.log")

    helpers do

      def asset_path(path)
        @asset_host ||= if settings.environment == :production
          "https://s3.amazonaws.com/assets.photon"
        else
          ""
        end
        "#{@asset_host}/#{path}"
      end

      def log(stuff)
        @log ||= begin
          if settings.environment == :development
            FileUtils.mkdir_p(File.dirname(self.class.log_file))
            File.open(self.class.log_file, "a")
          end
        end
        if @log
          @log.puts stuff
          @log.flush
        end
      end

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

