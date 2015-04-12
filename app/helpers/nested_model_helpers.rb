module Voting
  module NestedModelHelpers
    def self.included(klass)
      klass.extend(NMHClassMethods)
    end

    module NMHClassMethods
      def set_or_new(attrs)
        model = get(attrs.delete('id').to_i) || new
        model.attributes = attrs
        model
      end
    end
  end
end
