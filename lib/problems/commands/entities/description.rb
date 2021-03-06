# frozen_string_literal: true

require_relative 'problem_property'

module Commands
  # Represents the description of a problem.
  class Description < ProblemProperty
    DESCRIPTION_KEYWORD = 'description'

    validator args_size(3)
    validator keyword(DESCRIPTION_KEYWORD)
    validator for_keyword(1)

    def initialize(_, _, problem)
      @problem = problem
    end

    def edit
      "Edit description for #{@problem} problem"
    end

    def remove
      "Remove description value (if it is present) from #{@problem} problem"
    end
  end
end
