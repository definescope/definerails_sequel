class Object
  def metaclass
    class << self; self; end
  end
end


class Sequel::Model::Errors
  attr_accessor :model_instance

  def full_messages
    if model_instance.present?

      inject([]) do |m, kv|
        att, errors = *kv

        translation_scope = [
          model_instance.class.i18n_scope,
          :attributes,
          model_instance.class.model_name.to_s.downcase.to_sym
        ]

        if att.is_a?(Array)
          Array(att).map!{|v| I18n.translate(v,
                                             scope: translation_scope,
                                             default: v.to_s.humanize
                                             )}
        else
          att = I18n.translate(att,
                               scope: translation_scope,
                               default: att.to_s.humanize
                               )
        end

        errors.each {|e| m << (e.is_a?(Sequel::LiteralString) ? e : "#{Array(att).join(ATTRIBUTE_JOINER)} #{e}")}

        m
      end

    else
      map {|attribute, message| full_message(attribute, message)}

    end
  end
end


module DefineRails
  module Sequel

    # Done like this, instead of via simple inheritance, because Sequel models
    # apparently get screwed up with subclasses of subclasses! :-(
    Model = ::Sequel::Model
    # Model = Class.new(::Sequel::Model)
    # class Model
    # end

    module DefineRailsSequelModelExtensions

      def self.prepended(base)
        class << base
          prepend ClassMethods
        end
      end

      def errors
        errors = super

        errors.model_instance = self

        errors
      end

      module ClassMethods

        def inherited(subclass)
          super

          # Necessary for correct translation of attribute names
          subclass.metaclass.send(:define_method, :human_attribute_name) do |attr|
            I18n.translate(
              attr,
              scope: [
                subclass.i18n_scope,
                :attributes,
                subclass.model_name.i18n_key.to_s.downcase.to_sym
              ],
              default: attr.to_s.humanize
            )
          end
        end

        def def_Model(mod, method_name = nil)
          model = self

          method_name = :Model unless method_name.present?

          (class << mod; self; end).send(:define_method, method_name) do |source|

            if block_given?
              the_source = yield(source)
            else
              the_source = source
            end

            model.Model the_source

          end
        end

      end

    end

    class ::Sequel::Model
      prepend DefineRailsSequelModelExtensions
    end

  end
end
