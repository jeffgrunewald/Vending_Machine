# Implement the logic of a vending machine that accepts nickels, dimes, and quarters
# and dispenses cola, chips, and candy. More specific behaviors as described below.

class VendingMachine
    # Has accessors for valid coins and current amount.
    attr_accessor :current_amount, :valid_coins, :nickels, :dimes, :quarters, :cola, :chips, :candy

    # Hnit function sets initial values for attributes, enough coins to make change and 20 items of each product
    def initialize
        self.current_amount = 0
        self.valid_coins = []
        self.nickels, self.dimes, self.quarters = [40, 20, 8]
        self.cola, self.chips, self.candy = [({cost: 100, count: 20}), ({cost: 50, count: 20}), ({cost: 65, count: 20})]
    end

    # Coin interaction implemented as a method, representing dropping coins in the slot.
    # Convert coins inserted to upcase so "dime" and "DIME" treated the same; used upcase and not downcase because
    # specified output in all caps (for consistency). Calls display method (next) and returns invalid coins instead
    # of displaying them, simulating real machine dropping real invalid coin in coin return.
    # Anything can be entered, so treats any input not one of the three valid coins as an invalid coin.
    def insert coin
        coin = coin.upcase
        case coin
        when "NICKEL", "DIME", "QUARTER"
            self.valid_coins.push coin
            case coin
            when "NICKEL"
                self.current_amount += 5
            when "DIME"
                self.current_amount += 10
            when "QUARTER"
                self.current_amount += 25
            end
            self.display
        else
            return coin
        end
    end

    # Display method for user interaction, instruction.
    def display
        if self.current_amount > 0
            # Implmented money as int representing pennies and then format as cents/dollar because trying
            # to add/subtract floats is maddening.
            puts("CURRENT AMOUNT: #{"%.2f" % (self.current_amount / 100.0)}")
        else
            # Lowest coin levels to determine if exact change required determined by one coin less than needed
            # to equal next "value threshold". Ex: 3 quarters = 1 less than 1.00, 4 dimes = 1 less than 0.50, etc.
            if self.nickels <= 4 && self.dimes <= 4 && self.quarters <= 3
                puts "EXACT CHANGE ONLY"
            else
                puts "INSERT COIN"
            end
        end
    end

    # The big one - processes transactions based on user selection. Takes any input selection and treats any
    # not conforming to one three products as "invalid selection".
    def select product
        # Takes input and converts to upcase for consistency (again, just to conform to other specified output)
        product = product.upcase
        # Boolean to simplify processing; allows for single "output product and change" block when conditions
        # for individual items must be processed separately.
        dispense = false
        # Diff to calculate leftovers if customer adds more money than needed.
        diff = 0
        if ["COLA", "CHIPS", "CANDY"].include? product
            case product
            when "COLA"
                item = self.cola
            when "CHIPS"
                item = self.chips
            when "CANDY"
                item = self.candy
            end
            # As long as there is any product left from select option...
            if item[:count] > 0
                # And you've entered enough money
                if self.current_amount >= item[:cost]
                    # Store the amount of overage, if any
                    diff = self.current_amount - item[:cost]
                    # Approve the transaction for later
                    dispense = true
                    # Update the specific product count
                    item[:count] -= 1
                else
                    # Let them know they've come up short
                    puts "PRICE: #{"%.2f" % (item[:cost] / 100.0)}"
                end
            else
                # Skip all that if the product isn't available
                puts "SOLD OUT"
            end
            if dispense
                output = {product: product, change: []}
                puts "THANK YOU"
                self.valid_coins.each do |coin|
                    if coin == "NICKEL"
                        self.nickels += 1
                    elsif coin == "DIME"
                        self.dimes += 1
                    elsif coin == "QUARTER"
                        self.quarters += 1
                    end
                end
                self.valid_coins = []
                self.current_amount = 0
                while diff >= 25 && self.quarters > 0
                    diff -= 25
                    self.quarters -= 1
                    output[:change].push "QUARTER"
                end
                while diff >= 10 && self.dimes > 0
                    diff -= 10
                    self.dimes -= 1
                    output[:change].push "DIME"
                end
                while diff >= 5 && self.nickels > 0
                    diff -= 5
                    self.nickels -= 1
                    output[:change].push "NICKEL"
                end
                return output
            end
        else
            puts "INVALID SELECTION"
        end
    end

    def return
        output = self.valid_coins
        self.valid_coins = []
        self.current_amount = 0
        self.display
        return output
    end

    def service
        self.current_amount = 0
        self.valid_coins = []
        self.cola[:count], self.candy[:count], self.chips[:count] = [20, 20, 20]
        self.nickels, self.dimes, self.quarters = [40, 20, 8]
    end

end
