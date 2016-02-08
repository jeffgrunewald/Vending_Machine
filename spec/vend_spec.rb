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

    context "when newly serviced" do
        vendingMachine = VendingMachine.new

        it "should initialize attributes representing a fully-stocked machine" do
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
            expect(STDOUT).to receive(:puts).with("CURRENT AMOUNT: 0.40")
            vendingMachine.insert("quarter")
            expect(vendingMachine.current_amount).to be == 40
            expect(vendingMachine.valid_coins).to be == ["NICKEL", "DIME", "QUARTER"]
        end

        it "should reject invalid coins" do
            vendingMachine.insert("penny")
            expect(vendingMachine.current_amount).to be == 40
            expect(vendingMachine.valid_coins).to be == ["NICKEL", "DIME", "QUARTER"]
            expect(vendingMachine.insert "penny").to eq("PENNY")
        end
    end

    context "with depleted coin bins" do
        vendingMachine = VendingMachine.new

        vendingMachine.nickels, vendingMachine.dimes, vendingMachine.quarters = [4, 4, 3]

        it "should display requirement for exact change only before accepting coins" do
            expect(STDOUT).to receive(:puts).with("EXACT CHANGE ONLY")
            vendingMachine.display
        end
    end

    context "when able to make change" do

        it "should display request to insert coin before accepting coins" do
            expect(STDOUT).to receive(:puts).with("INSERT COIN")
            vendingMachine.display
        end

        it "should display the current amount entered once money has been inserted" do
            vendingMachine.current_amount = 85
            expect(STDOUT).to receive(:puts).with("CURRENT AMOUNT: 0.85")
            vendingMachine.display
        end
    end

    context "when transacting" do
        before(:example) do
            vendingMachine.current_amount = 100
        end

        it "should dispense selected product if current amount enough" do
            expect(vendingMachine.select "CANDY").to eq({product: "CANDY", change: []})
        end

        it "should subtract dispensed product from stock" do
            vendingMachine.select("COLA")
            expect(vendingMachine.cola[:count]).to be == 19
        end

        it "should empty the current amount and valid coins when a purchase is made" do
            vendingMachine.valid_coins = ["QUARTER", "QUARTER"]
            vendingMachine.select("CHIPS")
            expect(vendingMachine.current_amount).to be == 0
            expect(vendingMachine.valid_coins).to be == []
        end

        it "should thank the customer for a purchase" do
            expect(STDOUT).to receive(:puts).with("THANK YOU")
            vendingMachine.select("COLA")
        end

        it "should display sold out if selected item is unavailable" do
            vendingMachine.cola[:count] = 0
            expect(STDOUT).to receive(:puts).with("SOLD OUT")
            vendingMachine.select("COLA")
        end

        it "should deposit input coins properly" do
            vendingMachine.valid_coins = ["QUARTER", "QUARTER"]
            vendingMachine.select("CHIPS")
            expect(vendingMachine.quarters).to be == 10
        end
    end

end
