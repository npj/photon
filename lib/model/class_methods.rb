module Photon
  module Model
    module ClassMethods
      def self.included(base)
        class << base
          def class_methods(&block)
            instance_eval(&block)
          end
        end
      end
    end
  end
end
