# Implement the logic of a vending machine that accepts nickels, dimes, and quarters
# and dispenses cola, chips, and candy. More specific behaviors as described below.

class VendingMachine

    def initialize
        @current_amount = 0
        @current_coins = []
        @nickels = []
        @dimes = []
        @quarters = []
        @cola = []
        @chips = []
        @candy = []
    end

    def check_display
        if @current_amount > 0
            puts ("CURRENT AMOUNT: #{'%.2f' % (@current_amount / 100.0)}")
        else
            if @nickels.length <= 4 && @dimes.length <= 4 && @quarters.length <= 3
                puts 'EXACT CHANGE ONLY'
            else
                puts 'INSERT COIN'
            end
        end
    end

end
