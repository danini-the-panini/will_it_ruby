module Ahiru
  module ProcessorDelegateMethods
    def v_nil
      processor.v_nil
    end

    def v_true
      processor.v_true
    end

    def v_false
      processor.v_false
    end

    def v_bool
      processor.v_bool
    end

    def object_class
      processor.object_class
    end
  end
end