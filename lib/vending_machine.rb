# Implement the logic of a vending machine that accepts nickels, dimes, and quarters
# and dispenses cola, chips, and candy. More specific behaviors as described below.
require_relative './coins'
require_relative './products'
require_relative './coin_validator'

class VendingMachine

    def initialize
        @current_amount = 0
        @current_coins, @nickels, @dimes, @quarters = [],[],[],[]
        @cola = {price: 100, stock: []}
        @chips = {price: 50, stock: []}
        @candy = {price: 65, stock: []}
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
        # Pass inserted coin to validator function.
        case validate coin
        when 1
            @current_amount += 5
        when 2
            @current_amount += 10
        when 3
            @current_amount += 25
        when 0
            # Validator handles edge cases, so no "else". Returns invalid coins immediately.
            return coin
        end
        @current_coins.push coin
        check_display
    end

    def return_coins
        @current_amount = 0
        output = @current_coins
        @current_coins = []
        check_display
        return output
    end

    def select_product product
        if ['cola', 'chips', 'candy'].include? product
            case product
            when 'cola'
                item = @cola
            when 'chips'
                item = @chips
            when 'candy'
                item = @candy
            end
            if item[:stock].length > 0
                if @current_amount >= item[:price]
                    output = {}
                    output[:product] = item[:stock].pop
                    @current_coins.each do |coin|
                        case coin
                        when 1
                            @nickels.push coin
                        when 2
                            @dimes.push coin
                        when 3
                            @quarters.push coin
                        end
                    end
                    @current_coins = []
                    @current_amount = 0
                    puts 'THANK YOU'
                    return output
                else
                        puts "PRICE: #{'%.2f' % (item[:price] / 100.0)}"
                end
            else
                puts 'SOLD OUT'
            end
        else
            puts 'INVALID SELECTION'
        end
    end

    def service
        # Partially implemented to fill the machine since no accessors means no direct access to internal
        # coin bins or product stores.
        @current_amount = 0
        @current_coins = []
        # Fill all levels to specific maximums (40 nickels, 20 dimes, 8 quarters and 20 of each product).
        n_fill, d_fill, q_fill, p_fill = (40 - @nickels.length), (20 - @dimes.length), (8 - @quarters.length)
        cola_fill, chips_fill, candy_fill = (20 - @cola[:stock].length), (20 - @chips[:stock].length), (20 - @candy[:stock].length)
        (1..n_fill).each {@nickels.push Nickel.new}
        (1..d_fill).each {@dimes.push Dime.new}
        (1..q_fill).each {@quarters.push Quarter.new}
        (1..cola_fill).each {@cola[:stock].push Cola.new}
        (1..chips_fill).each {@chips[:stock].push Chips.new}
        (1..candy_fill).each {@candy[:stock].push Candy.new}
    end


end
