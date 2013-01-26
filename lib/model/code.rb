module Photon
  module Model
    module Code
      extend self

      def included(base)
        base.class_eval do
          include Photon::Utils

          field :code
          before_validation :generate_code, on: :create
          validates_uniqueness_of :code, on: :create

          private

            def generate_code
              begin
                code = random_string(length: 4)
              end while(code_scope.find_by(:code => code))
              self.code = code
            end
        end
      end
    end
  end
end
