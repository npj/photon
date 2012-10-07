module Photon
  module Albums
    class << self
      def registered(app)
        define_routes(app)
      end

      private

        def define_routes(app)

          app.before "/a/:code?" do
            @album = Album.find_by(code: params[:code])
          end

          app.post "/a" do
            if can?(:create, Album)
              album = Album.create_with_defaults(user: current_user)
              redirect "/a/#{album.code}"
            else
              redirect "/"
            end
          end

          app.get "/a/:code" do
            slim :'albums/show'
          end

          app.delete "/a/:code" do
            if can?(:destroy, @album)
              @album.destroy
            end
            redirect "/"
          end
        end
    end
  end
end
