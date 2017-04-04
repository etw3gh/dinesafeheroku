module StringContraints
  def self.matches? seg
    if :street.nil?
      return true
    end
    :street.length < 5
  end
end