require 'rspec'
require_relative '../lib/vending_machine'

describe 'Vending Machine' do
    subject(:vendingMachine) {VendingMachine.new}

    it 'has a method to display info to customers' do
        is_expected.to respond_to :check_display
    end

end
