module Accessors
  def attr_accessor_with_history(*names)
    names.each do |name|
      var_name = "@#{name}".to_sym
      var_history = "@#{name}_history".to_sym
      define_method("#{name}_history".to_sym) { instance_variable_get(var_history) }
      define_method(name) { instance_variable_get(var_name) }
      define_method("#{name}=".to_sym) do |value|
        old_history = instance_variable_get(var_history) || []
        instance_variable_set(var_history, old_history.append(value))
        instance_variable_set(var_name, value)
      end
    end
  end

  def strong_attr_accessor(name, attr_class)
    var_name = "@#{name}".to_sym
    define_method(name) { instance_variable_get(var_name) }
    define_method("#{name}=".to_sym) do |value|
      message = "Неверный тип данных. Ожидается #{attr_class}"
      raise message unless value.is_a?(attr_class)

      instance_variable_set(var_name, value)
    end
  end
end
