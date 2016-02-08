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
        is_expected.to respond_to :display
    end

    context "a new machine" do
        vendingMachine = VendingMachine.new

        it "should initialize attribute values representing a full machine ready to make change" do
            expect(vendingMachine.current_amount).to be == 0
            expect(vendingMachine.valid_coins).to be == []
            expect(vendingMachine.nickels).to be == 40
            expect(vendingMachine.candy).to be == {cost: 65, count: 20}
        end

        it "should accept valid coins and update attributes" do
            expect(STDOUT).to receive(:puts).with("CURRENT AMOUNT: 0.05")
            vendingMachine.insert("NICKEL")
            expect(vendingMachine.current_amount).to be == 5
            expect(vendingMachine.valid_coins).to be == ["NICKEL"]
            expect(STDOUT).to receive(:puts).with("CURRENT AMOUNT: 0.15")
            vendingMachine.insert("DIME")
            expect(vendingMachine.current_amount).to be == 15
            expect(vendingMachine.valid_coins).to be == ["NICKEL", "DIME"]
        end

        it "should accept correct coins regardless of their input case" do
            vendingMachine.insert("quarter")
            expect(vendingMachine.current_amount).to be == 40
            expect(vendingMachine.valid_coins).to be == ["NICKEL", "DIME", "QUARTER"]
        end

        it "should reject invalid coins" do
            expect(STDOUT).to receive(:puts).with("RETURNED PENNY")
            vendingMachine.insert("penny")
            expect(vendingMachine.current_amount).to be == 40
            expect(vendingMachine.valid_coins).to be == ["NICKEL", "DIME", "QUARTER"]
        end
    end

    context "a change-depleted machine" do
        vendingMachine = VendingMachine.new
        vendingMachine.nickels = 4
        vendingMachine.dimes = 4
        vendingMachine.quarters = 3

        it "should display requirement for exact change only when coin bins are low" do
            expect(STDOUT).to receive(:puts).with("EXACT CHANGE ONLY")
            vendingMachine.display
        end



    end

end
