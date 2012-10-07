#!/usr/bin/env ruby

root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

require File.join(root, 'photon.rb')

def upload_assets(dir, prefix = dir)

  Dir.open(dir).each do |entry|
    next if %w{ . .. }.include?(entry)
    path = File.join(dir, entry)

    if File.directory?(path)
      upload_assets(path, prefix)
    else
      puts "STORE: #{path.split(prefix).last}"
      AWS::S3::S3Object.store("#{path.split(prefix).last}", File.open(path), ENV['AWS_S3_BUCKET'], { access: :public_read })
    end
  end
end

upload_assets(File.join(root, 'public'))
