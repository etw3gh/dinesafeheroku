module StringContraints
  def self.matches? request
    puts YAML::dump(request)
    return true
    # if request.street.nil?
    #   return true
    # end
    # request.street.length < 5
  end
end