module Voting
  module PostHelpers
    def extract_attributes(attrs)
      (attrs || []).reject { |a| a.nil? || a.empty? }
    end
  end
end
