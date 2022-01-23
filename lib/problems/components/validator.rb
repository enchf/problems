# frozen_string_literal: true

require 'toolcase'

module Problems
  # Generic validator
  class Validator
    include Toolcase::Registry

    attr_accessor :predicate, :arguments, :reductor

    alias children registries
    alias add_child register

    def initialize(reductor: :all?,
                   arguments: Validator.all_arguments,
                   entity: nil,
                   &predicate)
      @predicate = block_given? ? predicate : Validator.default_predicate
      @arguments = arguments
      @reductor = reductor
      @entity = entity
    end

    def valid?(*args)
      final_args = arguments.call(*args)
      predicate.call(*final_args) && children.send(reductor) { |child| child.valid?(*args) }
    end

    def evaluate(&block)
      tap { |it| it.instance_eval(&block) }
    end

    class << self
      # Reductors
      def any
        :any?
      end

      def all
        :all?
      end

      # Argument providers
      def all_arguments
        proc { |*args| args }
      end

      def indexed_argument(index)
        proc { |*args| [args[index]] }
      end

      # Predicates
      def default_predicate
        proc { |*_| true }
      end
    end
  end
end
