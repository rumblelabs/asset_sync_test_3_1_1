AssetSync.configure do |config|
  config.aws_access_key_id = ENV['AWS_ACCESS_KEY']
  config.aws_secret_access_key = ENV['AWS_ACCESS_SECRET']
  config.fog_directory = ENV['AWS_BUCKET']
  config.fog_region = 'eu-west-1'
  config.existing_remote_files = "keep"
  # config.gzip_compression = true
end
