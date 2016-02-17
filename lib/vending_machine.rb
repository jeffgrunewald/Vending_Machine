require_relative './coins'
require_relative './products'
require_relative './coin_validator'
require_relative './calculate_change'

class VendingMachine

    def initialize
        @current_amount = 0
        # Coins as objects; machine identifies coin / determines value based on physical attributes.
        @nickels, @dimes, @quarters = [],[],[]
        # Products as objects; vendor determines how much to charge, so price is not inherent in product object.
        @cola = {price: 100, stock: []}
        @chips = {price: 50, stock: []}
        @candy = {price: 65, stock: []}
    end
#------------------------------------------
    def check_display
        if @current_amount > 0
            # Values calculated in cents and formated at output to avoid adding floats.
            puts "#{'%.2f' % (@current_amount / 100.0)}"
        else
            if @nickels.length <= 4 && @dimes.length <= 4 && @quarters.length <= 3
                puts 'EXACT CHANGE ONLY'
            else
                puts 'INSERT COIN'
            end
        end
    end
#------------------------------------------
    def accept_coin coin
        # Passes inserted coin to validator function.
        case validate coin
        when 1
            @current_amount += 5; @nickels.push coin
        when 2
            @current_amount += 10; @dimes.push coin
        when 3
            @current_amount += 25; @quarters.push coin
        when 0
            # Validator handles edge cases, so no "else". Returns invalid coins immediately.
            return coin
        end
        check_display
    end
#------------------------------------------
    def return_coins
        # Calculator function makes "change" for full amount inserted, no need to separately track coins inserted. 
        change = calc_change @current_amount, @nickels.length, @dimes.length, @quarters.length
        @current_amount = 0
        output = []
        (1..change[:quarters]).each { output.push(@quarters.pop) }
        (1..change[:dimes]).each { output.push(@dimes.pop) }
        (1..change[:nickels]).each { output.push(@nickels.pop) }
        check_display
        return output
    end
#------------------------------------------
    def select_product product
        product = product.downcase
        diff = 0
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
                    diff = @current_amount - item[:price]
                    # Product and change need to return together so output structured as hash of both.
                    output = {product: item[:stock].pop, change: []}

                    @current_amount = 0
                    # Passes remaining balance to calculator function to determine change.
                    change = calc_change diff, @nickels.length, @dimes.length, @quarters.length
                    (1..change[:quarters]).each { output[:change].push(@quarters.pop) }
                    (1..change[:dimes]).each { output[:change].push(@dimes.pop) }
                    (1..change[:nickels]).each { output[:change].push(@nickels.pop) }

                    puts 'THANK YOU'
                    return output

                else
                    puts "PRICE: #{'%.2f' % (item[:price] / 100.0)}"
                end

            else
                puts 'SOLD OUT'
                check_display
            end

        else
            puts 'INVALID SELECTION'
        end
    end
#------------------------------------------
    def service
        # Implemented to fill machine since no accessors means no direct access to internal coin or product stores.
        @current_amount = 0
        @current_coins = []
        n_fill, d_fill, q_fill, p_fill = (40 - @nickels.length), (20 - @dimes.length), (8 - @quarters.length)
        cola_fill, chips_fill, candy_fill = (20 - @cola[:stock].length), (20 - @chips[:stock].length), (20 - @candy[:stock].length)
        (1..n_fill).each { @nickels.push Nickel.new }
        (1..d_fill).each { @dimes.push Dime.new }
        (1..q_fill).each { @quarters.push Quarter.new }
        (1..cola_fill).each { @cola[:stock].push Cola.new }
        (1..chips_fill).each { @chips[:stock].push Chips.new }
        (1..candy_fill).each { @candy[:stock].push Candy.new }
    end
end
