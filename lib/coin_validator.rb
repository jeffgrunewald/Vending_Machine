# Abstract out the validation of coins. For easier vending machine code and
# assuming separate mechanism inside the machine performs the sorting.

def validate coin
    # Test if object is even a coin.
    if coin.respond_to?(:weight) && coin.respond_to?(:diameter)
        # If it is a coin, validate whether or not it is a nickel, dime, or quarter.
        if coin.weight == 5 && coin.diameter == 4
            return 1
        elsif coin.weight == 3 && coin.diameter == 2
            return 2
        elsif coin.weight == 7 && coin.diameter == 6
            return 3
        else
            return 0
        end
    else
        return 0
    end
end
