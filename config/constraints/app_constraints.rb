class Constraints
  def initialize(constraints = [])
    @constraints = constraints
  end

  def matches?(request)
    matches = true
    @constraints.each do |constraint|
      matches &&= constraint.matches?(request)
    end
    matches
  end
end