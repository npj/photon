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

          app.get '/a/:album_code/p/:code' do
            @photo = Photo.find_by(code: params[:code])
            slim :'photos/show'
          end

          app.post "/a/:album_code/p" do
            Tempfile.open(env['HTTP_X_FILE_NAME']) do |temp|
              temp.write(request.body.read)
              @album.photos.create({
                img: UploadedFile.new({
                      tempfile: temp,
                  content_type: env['CONTENT_TYPE'],
                      filename: env['HTTP_X_FILE_NAME']
                })
              })
            end
          end
        end
    end
  end
end
