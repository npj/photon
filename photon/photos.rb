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

          app.get "/a/:album_code/p/new" do
            slim :'photos/new'
          end

          app.get '/a/:album_code/p/:id' do
            @photo = Photo.find_by(code: params[:code])
            slim :'photos/show'
          end

          app.post "/a/:album_code/p" do
            Photo.create({
              album: @album,
                img: UploadedFile.new(params[:img])
            })
            redirect "/a/#{@album.code}/p/new"
          end
        end
    end
  end
end