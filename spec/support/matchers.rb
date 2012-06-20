RSpec::Matchers.define(:trigger) do |handler|
  match do |actual|
    @not_to_trigger ||= []
    @to_trigger ||= []
    @to_trigger << handler
    actual.call
    @to_trigger.all?(&:triggered?) && @not_to_trigger.none?(&:triggered?)
  end

  chain :but_not do |handler|
    @not_to_trigger ||= []
    @not_to_trigger << handler
  end

  chain :and_also do |handler|
    @to_trigger ||= []
    @to_trigger << handler
  end
end