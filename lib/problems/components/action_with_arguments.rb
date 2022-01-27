# frozen_string_literal: true

require_relative 'action'
require_relative 'context'

module Problems
  # An Action with arguments refering to an entity context.
  class ActionWithArguments < Action
    EXCLUDE_FROM_ARGUMENTS = %i[reserved_word].freeze

    def initialize(handler, action, &block)
      super(handler, action)

      instance_eval(&block)
      argument_validators.each { |instance, index| context.property(instance.entity, index) }
    end

    def context
      @context ||= Context.new
    end

    def arguments(*args)
      @context.build(*args)
    end

    def next_index
      validations.size
    end

    def all_validators
      validations.children
    end

    def argument_validators
      all_validators.each_with_index
                    .select { |instance, _| validations.children(:argument).include?(instance) }
    end

    def size_valid?(size)
      min = 0
      max = 0

      validator_types.each do |type|
        min += 1 unless %i[optional varargs].include?(type)
        max = type == :varargs ? Float::INFINITY : max + 1
      end

      size >= min && size <= max
    end

    def validations
      action = self
      @validations ||= Validator.new do |*args|
        action.size_valid?(args.size)
      end
    end

    # Methods to add validators to arguments

    def varargs(**config, &block)
      config[:arguments] = Validator.tail(next_index)

      config_per_argument = config.clone.tap { |cfg| cfg[:arguments] = Validator.indexed_argument(0) }
      validator_per_argument = Validator.new(**config_per_argument).evaluate(&block)

      validator = Validator.new(**config) do |*args|
        args.all? { |argument| validator_per_argument.valid?(argument) }
      end

      validations.add_child(validator)
      validator_types << :varargs
    end

    def add_validator(validator, argument: true, type: :custom)
      validator.arguments = Validator.indexed_argument(next_index)
      tag = argument ? :argument : nil
      validator_types << type
      validations.add_child(validator, tag: tag)
    end

    private

    def validator_types
      @validator_types ||= []
    end
  end
end
