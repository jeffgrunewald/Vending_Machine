require 'rspec'
require_relative '../lib/vending_machine'

describe 'Vending Machine' do
    subject(:vendingMachine) {VendingMachine.new}

    it 'has a method to display info to customers' do
        is_expected.to respond_to :check_display
    end

    it 'should display "INSERT COIN" when current amount is zero' do
        expect(STDOUT).to receive(:puts).with('INSERT COIN')
        vendingMachine.check_display
    end

    it 'should display "EXACT CHANGE ONLY" when coin are low' do
        expect(STDOUT).to receive(:puts).with('EXACT CHANGE ONLY')
        vendingMachine.check_display
    end

end
