module WillItRuby
  class Argument
    attr_reader :name, :default

    def initialize(name, default=nil)
      @name = name
      @default = default
    end

    def optional?
      !required?
    end

    def required?
      @default.nil?
    end
  end
end