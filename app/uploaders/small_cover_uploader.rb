class SmallCoverUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url
    "/small_placeholder.jpg"
  end

  version :thumb do
    process :resize_to_fit => [166, 236]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
