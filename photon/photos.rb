module Photon
  module Photos
    class << self
      def registered(app)
        define_routes(app)
      end

      private

        def define_routes(app)

          app.before '/a/:album_code/*' do
            @album = Album.find_by(code: params[:album_code])
          end

          app.get '/a/:album_code/p/:code?' do
            @photo = @album.photos.find_by(code: params[:code])
            if params[:thumb] == "true"
              slim :'photos/thumb', layout: false
            else
              slim :'photos/show'
            end
          end

          app.post "/a/:album_code/p" do
            if can?(:create, Photo)
              photo          = @album.photos.build
              photo.img      = request.body.read
              photo.img_name = env['HTTP_X_FILE_NAME']
              photo.save

              photo.code
            else
              401
            end
          end

          app.delete "/a/:album_code/p/:code" do
            @photo = @album.photos.find_by(code: params[:code])
            if can?(:destroy, @photo)
              @photo.destroy
            end
            redirect "/a/#{@album.code}"
          end
        end
    end
  end
end
