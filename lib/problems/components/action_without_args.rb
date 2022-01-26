# frozen_string_literal: true

require 'problems/validation/validator'

require_relative 'action'

module Problems
  # An action without arguments
  class ActionWithoutArgs < Action
    EMPTY_ARGS_VALIDATOR = Validator.new { |*args| args.empty? }

    def initialize(handler, action)
      super(handler, action)
      validations.add_child(EMPTY_ARGS_VALIDATOR)
    end

    def arguments
      []
    end
  end
end