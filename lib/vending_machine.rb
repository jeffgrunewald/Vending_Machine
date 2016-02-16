# Implement the logic of a vending machine that accepts nickels, dimes, and quarters
# and dispenses cola, chips, and candy. More specific behaviors as described below.
require_relative './coins'
require_relative './products'

class VendingMachine

    def initialize
        @current_amount = 0
        @current_coins, @nickels, @dimes, @quarters, @cola, @chips, @candy = [],[],[],[],[],[],[]
    end

    def check_display
        if @current_amount > 0
            puts ("#{'%.2f' % (@current_amount / 100.0)}")
        else
            if @nickels.length <= 4 && @dimes.length <= 4 && @quarters.length <= 3
                puts 'EXACT CHANGE ONLY'
            else
                puts 'INSERT COIN'
            end
        end
    end

    def accept_coin coin

    end

    def service
        @current_amount = 0
        @current_coins = []
        n_fill, d_fill, q_fill, p_fill = (40 - @nickels.length), (20 - @dimes.length), (8 - @quarters.length)
        cola_fill, chips_fill, candy_fill = (20 - @cola.length), (20 - @chips.length), (20 - @candy.length)
        (1..n_fill).each {@nickels.push Nickel.new}
        (1..d_fill).each {@dimes.push Dime.new}
        (1..q_fill).each {@quarters.push Quarter.new}
    end


end
