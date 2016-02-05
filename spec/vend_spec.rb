require "rspec"
require_relative "../lib/vend"

describe "Vending Machine" do
    subject(:vendingMachine) {VendingMachine.new}

    it "has accessors for current amount, valid coins, products sold, and coins entered" do
        is_expected.to respond_to(:current_amount)
        is_expected.to respond_to(:current_coins)
        is_expected.to respond_to(:dimes)
        is_expected.to respond_to(:cola)
    end

    it "should initialize attribute values representing a full machine ready to make change" do
        expect(vendingMachine.current_amount).to be == 0
        expect(vendingMachine.current_coins).to be == []
        expect(vendingMachine.nickels).to be == 40
        expect(vendingMachine.candy).to be == {cost: 0.65, count: 20}
    end

end
