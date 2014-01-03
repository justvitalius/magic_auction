# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
     ActionController::Base.helpers.asset_path("fallback/categories/" + [version_name, "default.png"].compact.join('_'))
  end

  #Create different versions of your uploaded files:
  version :xxs do
    process :resize_to_fill => [24, 24]
  end

  version :xs do
     process :resize_to_fill => [64, 64]
  end

  version :s do
    process :resize_to_fill => [128, 128]
  end

  version :m do
    process :resize_to_fill => [256, 256]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
