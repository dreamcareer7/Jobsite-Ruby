class ImageDimensionsValidator < ActiveModel::EachValidator
  #adapted from:
  #http://agis.io/2012/09/14/validating-paperclip-image-dimensions-in-rails.html

  def validate_each(record, attribute, value)
    return if value.queued_for_write.blank?

    dimensions = Paperclip::Geometry.from_file(value.queued_for_write[:original].path)
    width = options[:width]
    height = options[:height]

    record.errors[attribute] << "Width must be #{width}px" unless dimensions.width == width || width.blank?
    record.errors[attribute] << "Height must be #{height}px" unless dimensions.height == height || height.blank?
  end

end
