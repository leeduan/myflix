class LargeCoverUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  storage :fog

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url
    "/large_placeholder.jpg"
  end

  version :thumb do
    process :resize_to_fit => [665, 375]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
