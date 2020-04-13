module Validity
  def valid?
    validate!
    true
  rescue
    false
  end
end
