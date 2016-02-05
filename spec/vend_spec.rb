require "rspec"
require_relative "../lib/vend"

describe "Vending Machine" do
    subject(:vendingMachine) {VendingMachine.new}

    it "has an accessor for current amount" do
        is_expected.to respond_to(:current_amount)
    end

end
