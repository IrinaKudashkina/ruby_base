module Validation
  def self.included(base)
    base.instance_variable_set(:@validate_methods, [])
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_accessor :validate_methods

    def validate(attr_name, valid_type, *args)
      method_name = "validate_#{attr_name}_#{valid_type}".to_sym
      presence_valid(method_name, attr_name) if valid_type == :presence
      format_valid(method_name, attr_name, args[0]) if valid_type == :format
      type_valid(method_name, attr_name, args[0]) if valid_type == :type
      @validate_methods << method_name
    end

    def presence_valid(method_name, attr_name)
      define_method(method_name) do
        raise "Отсутствует значение атрибута #{attr_name}!" if send(attr_name).nil?
      end
    end

    def format_valid(method_name, attr_name, format)
      define_method(method_name) do
        raise "Неправильный формат атрибута #{attr_name}!" if send(attr_name) !~ format
      end
    end

    def type_valid(method_name, attr_name, class_name)
      define_method(method_name) do
        unless send(attr_name).is_a?(class_name)
          raise "Неправильный тип атрибута #{attr_name}! Ожидается: #{class_name}"
        end
      end
    end
  end

  module InstanceMethods
    def validate!
      self.class.validate_methods.each { |method| send(method.to_sym) }
    end

    def valid?
      validate!
      true
    rescue StandardError
      false
    end
  end
end
