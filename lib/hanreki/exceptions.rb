class ValidationError < StandardError
  attr_reader :event

  def initialize(event)
    super
    @event = event
  end
end
