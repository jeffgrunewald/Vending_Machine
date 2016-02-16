# Class definitions for valid coin types with attributes for determining value

class Nickel
    attr_reader :weight, :diameter

    def initialize
        @weight = 5
        @diameter = 4
    end
end

class Dime
    attr_reader :weight, :diameter

    def initialize
        @weight = 3
        @diameter = 2
    end
end

class Quarter
    attr_reader :weight, :diameter

    def initialize
        @weight = 7
        @diameter = 6
    end
end
