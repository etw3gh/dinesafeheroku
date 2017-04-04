module StringContraints
  def self.matches? seg
    if seg.street.nil?
      return true
    end
    seg.street.length < 5
  end
end