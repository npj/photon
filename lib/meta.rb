module Photon
  class Meta
    def initialize(&block)
      (class << self; self; end).class_eval(&block)
    end
  end
end
