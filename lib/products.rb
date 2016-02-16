# Class definitions for vending machine products with values

class Cola
    attr_reader :price

    def initialize
        @price = 100
    end
end

class Chips
    attr_reader :price

    def initialize
        @price = 50
    end
end

class Candy
    attr_reader :price

    def initialize
        @price = 65
    end
end
