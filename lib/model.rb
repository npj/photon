module Photon
  module Model
    def self.included(base)
      base.class_eval do
        include Mongoid::Document
        include Mongoid::Timestamps

        include ClassMethods
      end
    end
  end
end
