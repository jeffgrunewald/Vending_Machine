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
            expect(vendingMachine.current_amount).to eq 0
            expect(vendingMachine.valid_coins).to eq []
            expect(vendingMachine.nickels).to eq 40
            expect(vendingMachine.candy).to eq({cost: 65, count: 20})
        end

        it "should accept valid coins and update attributes" do
            expect(STDOUT).to receive(:puts).with("CURRENT AMOUNT: 0.05")
            vendingMachine.insert "NICKEL"
            expect(vendingMachine.current_amount).to eq 5
            expect(vendingMachine.valid_coins).to eq ["NICKEL"]
            expect(STDOUT).to receive(:puts).with("CURRENT AMOUNT: 0.15")
            vendingMachine.insert "DIME"
            expect(vendingMachine.current_amount).to eq 15
            expect(vendingMachine.valid_coins).to eq ["NICKEL", "DIME"]
        end

        it "should accept correct coins regardless of their input case" do
            expect(STDOUT).to receive(:puts).with("CURRENT AMOUNT: 0.40")
            vendingMachine.insert "quarter"
            expect(vendingMachine.current_amount).to eq 40
            expect(vendingMachine.valid_coins).to eq ["NICKEL", "DIME", "QUARTER"]
        end

        it "should reject invalid coins" do
            vendingMachine.insert "penny"
            expect(vendingMachine.current_amount).to eq 40
            expect(vendingMachine.valid_coins).to eq ["NICKEL", "DIME", "QUARTER"]
            expect(vendingMachine.insert "penny").to eq "PENNY"
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
            expect((vendingMachine.select "CANDY")[:product]).to eq "CANDY"
        end

        it "should subtract dispensed product from stock" do
            vendingMachine.select "COLA"
            expect(vendingMachine.cola[:count]).to eq 19
        end

        it "should empty the current amount and valid coins when a purchase is made" do
            vendingMachine.valid_coins = ["QUARTER", "QUARTER"]
            vendingMachine.select "CHIPS"
            expect(vendingMachine.current_amount).to eq 0
            expect(vendingMachine.valid_coins).to eq []
        end

        it "should thank the customer for a purchase" do
            expect(STDOUT).to receive(:puts).with("THANK YOU")
            vendingMachine.select "COLA"
        end

        it "should display sold out if selected item is unavailable" do
            vendingMachine.cola[:count] = 0
            expect(STDOUT).to receive(:puts).with("SOLD OUT")
            vendingMachine.select "COLA"
        end

        it "should deposit input coins properly" do
            vendingMachine.valid_coins = ["QUARTER", "QUARTER", "QUARTER", "DIME", "DIME", "NICKEL"]
            vendingMachine.select "CANDY"
            expect(vendingMachine.quarters).to eq 10
            expect(vendingMachine.dimes).to eq 21
            expect(vendingMachine.nickels).to eq 41
        end

        it "should return change if any is left over after purchase" do
            expect(vendingMachine.select "CANDY").to eq({product: "CANDY", change: ["QUARTER", "DIME"]})
        end

        it "should re-display the price of an item when current amount is not enough" do
            vendingMachine.current_amount = 50
            expect(STDOUT).to receive(:puts).with("PRICE: 0.65")
            vendingMachine.select "CANDY"
        end
    end

    it "should return customer's change when selected" do
        ["DIME", "QUARTER", "NICKEL", "DIME"].each {|coin| vendingMachine.insert coin}
        expect(STDOUT).to receive(:puts).with("INSERT COIN")
        expect(vendingMachine.return).to eq ["DIME", "QUARTER", "NICKEL", "DIME"]
        expect(vendingMachine.current_amount).to eq 0
        expect(vendingMachine.valid_coins).to eq []
    end

    it "should reset products and coins when serviced" do
        vendingMachine.nickels, vendingMachine.dimes, vendingMachine.quarters,
        vendingMachine.cola[:count], vendingMachine.candy[:count], vendingMachine.chips[:count] = 0
        vendingMachine.service
        expect(vendingMachine.nickels).to eq 40
        expect(vendingMachine.dimes).to eq 20
        expect(vendingMachine.quarters).to eq 8
        expect(vendingMachine.cola[:count]).to eq 20
        expect(vendingMachine.candy[:count]).to eq 20
        expect(vendingMachine.chips[:count]).to eq 20
    end

end
