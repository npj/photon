class UploadedFile
  attr_reader :original_filename, :content_type, :tempfile
  def initialize(hash)
    @original_filename = hash[:filename]
    @content_type      = hash[:content_type]
    @tempfile          = hash[:tempfile]
  end
end
