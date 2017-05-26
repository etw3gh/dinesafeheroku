class FileHelper
  # true if filepath_or_name ends with one of the formats in Rails.application.config.text_formats
  # see config/text_formats.rb
  def is_text(filepath_or_name)
    fn = filepath_or_name.strip.downcase
    Rails.application.config.text_formats.any? { |ftype| fn.ends_with?(ftype) }
  end

  def write_mode(filepath_or_name)
    if (self.is_text(filepath_or_name))
      return 'w'
    else
      return 'wb'
    end
  end
end