module DefineRails
  module Sequel

    module SequelBaseLocator
      def locate(gid)
        if defined?(::Sequel::Model) && gid.model_class < Sequel::Model
          gid.model_class.with_pk!(gid.model_id)
        else
          super
        end
      end

      private

      def find_records(model_class, ids, options)
        if defined?(::Sequel::Model) && model_class < Sequel::Model
          model_class.where(model_class.primary_key => ids).tap do |result|
            if !options[:ignore_missing] && result.count < ids.size
              fail Sequel::NoMatchingRow
            end
          end.all
        else
          super
        end
      end
    end

    ::GlobalID::Locator::BaseLocator.prepend SequelBaseLocator
    ::Sequel::Model.send(:include, ::GlobalID::Identification)

  end
end
