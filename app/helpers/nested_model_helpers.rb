module Voting
  module NestedModelHelpers
    def self.included(klass)
      klass.extend(NMHClassMethods)
    end

    module NMHClassMethods
      def set_or_new(attrs)
        attrs = Hash[attrs.reject { |_, v| v.nil? || v.empty? }]
        return if attrs.empty?

        model = get(attrs.delete('id').to_i) || new
        model.attributes = attrs
        model
      end
    end
  end
end
