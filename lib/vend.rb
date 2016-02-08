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
        self.quarters = 8
        self.cola = {cost: 1.00, count: 20}
        self.chips = {cost: 0.50, count: 20}
        self.candy = {cost: 0.65, count: 20}
    end

    def insert coin
        coin = coin.upcase
        case coin
        when "NICKEL", "DIME", "QUARTER"
            self.valid_coins.push(coin)
            case coin
            when "NICKEL"
                self.current_amount += 0.05
            when "DIME"
                self.current_amount += 0.10
            when "QUARTER"
                self.current_amount += 0.25
            end
            self.current_amount = self.current_amount.round(2)
            puts("CURRENT AMOUNT: #{self.current_amount}")
        else
            puts("RETURNED #{coin}")
        end
    end

    def select product

    end

    def display
        if self.current_amount > 0
            puts("CURRENT AMOUNT: #{self.current_amount}")
        else
            if self.nickels <= 4 && self.dimes <= 4 && self.quarters <= 3
                puts("EXACT CHANGE ONLY")
            else
                puts("INSERT COIN")
            end
        end
    end

    def return

    end

end
