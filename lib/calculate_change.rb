def calc_change difference, nickels, dimes, quarters

    change = {nickels: 0, dimes: 0, quarters: 0}

    while difference >= 25 && quarters > 0
        difference -= 25
        change[:quarters] += 1
    end

    while difference >= 10 && dimes > 0
        difference -= 10
        change[:dimes] += 1
    end

    while difference >= 5 && nickels > 0
        difference -= 5
        change[:nickels] += 1
    end

    return change
    
end
