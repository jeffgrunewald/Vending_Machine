# Implement the logic of a vending machine that accepts nickels, dimes, and quarters
# and dispenses cola, chips, and candy. More specific behaviors as described below.

class VendingMachine
    # Has accessors for valid coins and current amount.
    attr_accessor :current_amount, :valid_coins, :nickels, :dimes, :quarters, :cola, :chips, :candy

    def initialize
        self.current_amount = 0
        self.valid_coins = []
        self.nickels, self.dimes, self.quarters = [40, 20, 8]
        self.cola, self.chips, self.candy = [({cost: 100, count: 20}), ({cost: 50, count: 20}), ({cost: 65, count: 20})]
    end

    def insert coin
        coin = coin.upcase
        case coin
        when "NICKEL", "DIME", "QUARTER"
            self.valid_coins.push(coin)
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

    def display
        if self.current_amount > 0
            puts("CURRENT AMOUNT: #{"%.2f" % (self.current_amount / 100.0)}")
        else
            if self.nickels <= 4 && self.dimes <= 4 && self.quarters <= 3
                puts "EXACT CHANGE ONLY"
            else
                puts "INSERT COIN"
            end
        end
    end

    def select product
        product = product.upcase
        dispense = false
        diff = 0
        if ["COLA", "CHIPS", "CANDY"].include? product
            case product
            when "COLA"
                if self.cola[:count] > 0
                    if self.current_amount >= self.cola[:cost]
                        diff = self.current_amount - self.cola[:cost]
                        dispense = true
                        self.cola[:count] -= 1
                    else
                        puts "PRICE: #{"%.2f" % (self.cola[:cost] / 100.0)}"
                    end
                else
                    puts "SOLD OUT"
                end
            when "CHIPS"
                if self.chips[:count] > 0
                    if self.current_amount >= self.chips[:cost]
                        diff = self.current_amount - self.chips[:cost]
                        dispense = true
                        self.chips[:count] -= 1
                    else
                        puts "PRICE: #{"%.2f" % (self.chips[:cost] / 100.0)}"
                    end
                else
                    puts "SOLD OUT"
                end
            when "CANDY"
                if self.candy[:count] > 0
                    if self.current_amount >= self.candy[:cost]
                        diff = self.current_amount - self.candy[:cost]
                        dispense = true
                        self.candy[:count] -= 1
                    else
                        puts "PRICE: #{"%.2f" % (self.candy[:cost] / 100.0)}"
                    end
                else
                    puts "SOLD OUT"
                end
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
        puts "INSERT COIN"
        return output
    end

    def service
        self.current_amount = 0
        self.valid_coins = []
        self.cola[:count], self.candy[:count], self.chips[:count] = [20, 20, 20]
        self.nickels, self.dimes, self.quarters = [40, 20, 8]
    end

end
