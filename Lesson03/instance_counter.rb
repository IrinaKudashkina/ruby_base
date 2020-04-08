module InstanceCounter
  def self.included(base)
    base.instance_variable_set(:@instances, 0)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_accessor :instances
  end

  module InstanceMethods
    private
    def register_instance
      self.class.instances += 1
    end
  end
end
