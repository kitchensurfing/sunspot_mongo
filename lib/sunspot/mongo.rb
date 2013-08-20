require 'sunspot'
require 'sunspot/rails'

module Sunspot
  module Mongo
    def self.included(base)
      base.class_eval do
        extend Sunspot::Rails::Searchable::ActsAsMethods
        Sunspot::Adapters::DataAccessor.register(DataAccessor, base)
        Sunspot::Adapters::InstanceAdapter.register(InstanceAdapter, base)
      end
    end

    class InstanceAdapter < Sunspot::Adapters::InstanceAdapter
      def id
        @instance.id
      end
    end

    class DataAccessor < Sunspot::Adapters::DataAccessor
      attr_accessor :include

      def initialize(clazz)
        super(clazz)
        @inherited_attributes = [:include]
      end

      def load(id)
        @clazz.find(id)
      end

      def load_all(ids)
        if @include.present?
          @clazz.includes(@include).find(ids)
        else
          @clazz.find(ids)
        end
      end
    end
  end
end
