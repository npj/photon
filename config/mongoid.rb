Mongoid.load!(ERB.new(File.join(File.dirname(__FILE__), "files", "mongoid.yml.erb")).result)
