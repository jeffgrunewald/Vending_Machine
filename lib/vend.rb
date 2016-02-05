# Implement the logic of a vending machine that accepts nickels, dimes, and quarters
# and dispenses cola, chips, and candy. More specific behaviors as described below.

class VendingMachine
    # Has accessors for valid coins and current amount.
    attr_accessor :current_amount, :current_coins, :nickels, :dimes, :quarters, :cola, :chips, :candy

    def initialize
        self.current_amount = 0
        self.current_coins = []
        self.nickels = 40
        self.dimes = 20
        self.quarters = 4
        self.cola = {cost: 1.00, count: 20}
        self.chips = {cost: 0.50, count: 20}
        self.candy = {cost: 0.65, count: 20}
    end

end
