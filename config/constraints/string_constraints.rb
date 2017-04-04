module StringContraints
  def self.matches? request
    puts request
    if request.street.nil?
      return true
    end
    request.street.length < 5
  end
end