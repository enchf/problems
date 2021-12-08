# frozen_string_literal: true

require_relative 'match'

# Match expectation that search for the unimplemented warning string.
class Unimplemented < Match
  UNIMPLEMENTED = 'UNIMPLEMENTED'
  MATCH_STRING = '^Action ([a-z]+) is not defined for (.+)$'

  def self.accept?(config)
    UNIMPLEMENTED == config
  end

  def match_string
    MATCH_STRING
  end
end
