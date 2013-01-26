module Photon
  module Comments
    extend self

    def registered(app)
      define_routes(app)
    end

    private

      def define_routes(app)

        app.before '/a/:album_code/*' do
          @album = Album.find_by(code: params[:album_code])
        end

        app.post "/a/:album_code/c" do
          if can?(:create, Comment.new(commentable: @album))
            comment = @album.comments.build(user: current_user, body: params[:comment][:body])
            if comment.save
              comment.code
            else
              400
            end
          else
            401
          end
        end

        app.delete "/a/:album_code/c/:code" do
          comment = @album.comments.find_by(code: params[:code])
          if can?(:destroy, comment)
            comment.destroy
          end
          redirect "/a/#{@album.code}"
        end
      end
  end
end
