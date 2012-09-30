module Photon
  module Albums
    class << self
      def registered(app)
        define_routes(app)
      end

      private

        def define_routes(app)

          app.before "/a/:code/*" do
            @album = Album.find_by(code: params[:code])
          end

          app.post "/a" do
            album = Album.create_with_defaults(user: current_user)
            redirect "/a/#{album.code}/edit"
          end

          app.get "/a/:code/edit" do
            slim :'albums/edit'
          end
        end
    end
  end
end
