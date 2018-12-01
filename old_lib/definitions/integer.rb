require 'gemologist/definition'

module Gemologist
  Definition.add_class_definition(Integer) do
    # TODO: fill this out, just putting it in to make the tests work for now
    add_method_definition :+, T(Integer) => T(Integer)
  end
end