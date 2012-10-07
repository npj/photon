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
              photo = nil

              Tempfile.open(env['HTTP_X_FILE_NAME']) do |temp|
                temp.write(request.body.read)
                photo = @album.photos.create({
                  img: UploadedFile.new({
                        tempfile: temp,
                   content_type: env['CONTENT_TYPE'],
                        filename: env['HTTP_X_FILE_NAME']
                  })
                })
              end

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
