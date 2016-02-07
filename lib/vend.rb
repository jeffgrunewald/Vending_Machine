# Implement the logic of a vending machine that accepts nickels, dimes, and quarters
# and dispenses cola, chips, and candy. More specific behaviors as described below.

class VendingMachine
    # Has accessors for valid coins and current amount.
    attr_accessor :current_amount, :valid_coins, :invalid_coins, :nickels, :dimes, :quarters, :cola, :chips, :candy

    def initialize
        self.current_amount = 0
        self.valid_coins = []
        self.invalid_coins = []
        self.nickels = 40
        self.dimes = 20
        self.quarters = 4
        self.cola = {cost: 1.00, count: 20}
        self.chips = {cost: 0.50, count: 20}
        self.candy = {cost: 0.65, count: 20}
    end

    def insert coin
        case coin
        when "nickel", "dime", "quarter"
            self.valid_coins.push(coin)
            case coin
            when "nickel"
                self.current_amount += 0.05
            when "dime"
                self.current_amount += 0.10
            when "quarter"
                self.current_amount += 0.25
            end
            self.current_amount = self.current_amount.round(2)
            puts("Current amount: #{self.current_amount}")
        else
            puts("Returned #{coin}")
        end
    end

    def select product

    end

    def display

    end

    def return

    end

end
