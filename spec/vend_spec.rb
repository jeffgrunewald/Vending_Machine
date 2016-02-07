require "rspec"
require_relative "../lib/vend"

describe "Vending Machine" do
    subject(:vendingMachine) {VendingMachine.new}

    it "has accessors for current amount, valid coins, products sold, and coins entered" do
        is_expected.to respond_to :current_amount
        is_expected.to respond_to :valid_coins
        is_expected.to respond_to :dimes
        is_expected.to respond_to :cola
    end

    it "has methods for inserting coins, selecting products, checking display, and returning coins" do
        is_expected.to respond_to :insert
        is_expected.to respond_to :return
        is_expected.to respond_to :select
        is_expected.to respond_to :check
    end

    context "with a new machine" do
        vendingMachine = VendingMachine.new

        it "should initialize attribute values representing a full machine ready to make change" do
            expect(vendingMachine.current_amount).to be == 0
            expect(vendingMachine.valid_coins).to be == []
            expect(vendingMachine.nickels).to be == 40
            expect(vendingMachine.candy).to be == {cost: 0.65, count: 20}
        end

        it "should accept valid coins and update attributes" do
            expect(STDOUT).to receive(:puts).with("Current amount: 0.05")
            vendingMachine.insert("nickel")
            expect(vendingMachine.current_amount).to be == 0.05
            expect(vendingMachine.valid_coins).to be == ["nickel"]
            expect(vendingMachine.nickels).to be == 41
            expect(output) == "Current amount: 0.05"
            expect(STDOUT).to receive(:puts).with("Current amount: 0.15")
            vendingMachine.insert("dime")
            expect(vendingMachine.current_amount).to be == 0.15
            expect(vendingMachine.valid_coins).to be == ["nickel", "dime"]
            expect(vendingMachine.dimes).to be == 21
        end

        it "should reject invalid coins" do
            expect(STDOUT).to receive(:puts).with("Returned penny")
            vendingMachine.insert("penny")
            expect(vendingMachine.current_amount).to be == 0.15
            expect(vendingMachine.valid_coins).to be == ["nickel", "dime"]
        end
    end

end
