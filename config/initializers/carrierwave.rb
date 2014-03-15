CarrierWave.configure do |config|
  if Rails.env.production? || Rails.env.development?
    config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => ENV['S3_KEY'],
      :aws_secret_access_key  => ENV['S3_SECRET'],
      :region                 => 'us-west-2'
    }
    config.fog_directory    = ENV['S3_BUCKET_NAME']
    config.storage = :fog
    config.root = Rails.root.join('tmp')
    config.cache_dir = 'carrierwave'
  else
    config.storage = :file
    config.enable_processing = false
  end
end