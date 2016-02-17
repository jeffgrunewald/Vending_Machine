require 'rspec'
require_relative '../lib/vending_machine'
require_relative '../lib/coins'
require_relative '../lib/products'

describe 'Vending Machine' do
    subject(:vendingMachine) {VendingMachine.new}

    it 'has a method to display info to customers' do
        is_expected.to respond_to :check_display
    end

    it 'should display "EXACT CHANGE ONLY" when coins are low' do
        expect(STDOUT).to receive(:puts).with('EXACT CHANGE ONLY')
        vendingMachine.check_display
    end

    it 'should have a method for customers to insert coins' do
        is_expected.to respond_to :accept_coin
    end

    it 'should display "0.25" when a single quarter is inserted' do
        expect(STDOUT).to receive(:puts).with('0.25')
        vendingMachine.accept_coin Quarter.new
    end

    it 'should display "0.25" and "0.35" when a dime is inserted after a quarter' do
        expect(STDOUT).to receive(:puts).with('0.25')
        vendingMachine.accept_coin Quarter.new
        expect(STDOUT).to receive(:puts).with('0.35')
        vendingMachine.accept_coin Dime.new
    end

    it 'should return invalid coins' do
        expect(vendingMachine.accept_coin :anything_else).to eq :anything_else
    end

    it 'should have a method for customers to request return of their coins' do
        is_expected.to respond_to :return_coins
    end

    it 'should have a method for selecting products' do
        is_expected.to respond_to :select_product
    end

    it 'should display "SOLD OUT" follow by "0.10" when a dime is added and a missing product is selected' do
        vendingMachine.accept_coin Dime.new
        expect(STDOUT).to receive(:puts).with('SOLD OUT')
        expect(STDOUT).to receive(:puts).with('0.10')
        vendingMachine.select_product 'cola'
    end

    context 'when fully stocked' do
        vendingMachine = VendingMachine.new
        vendingMachine.service

        it 'should display "INSERT COIN" when current amount is zero' do
            expect(STDOUT).to receive(:puts).with('INSERT COIN')
            vendingMachine.check_display
        end

        it 'should display "INSERT COIN" when inserted coins are returned' do
            vendingMachine.accept_coin Nickel.new
            expect(STDOUT).to receive(:puts).with('INSERT COIN')
            vendingMachine.return_coins
        end

        it 'should display "PRICE: 0.65" when candy is selected and current amount is not enough' do
            expect(STDOUT).to receive(:puts).with('PRICE: 0.65')
            vendingMachine.select_product 'candy'
        end

        context 'and when two quarters have been inserted' do
            before(:example) do
                vendingMachine.accept_coin Quarter.new
                vendingMachine.accept_coin Quarter.new
            end

            it 'should output [Quarter, Quarter] when two dimes are inserted and then returned' do
                output = vendingMachine.return_coins
                expect(output[0].instance_of? Quarter).to eq true
                expect(output[1].instance_of? Quarter).to eq true
            end

            it 'should output {product: Chips} when current amount is 0.50 and "chips" is selected' do
                output = vendingMachine.select_product 'chips'
                expect(output[:product].instance_of? Chips).to eq true
            end

            it 'should display "THANK YOU" when a purchase is completed' do
                expect(STDOUT).to receive(:puts).with('THANK YOU')
                vendingMachine.select_product 'chips'
            end

            it 'should output {product: Candy, change: [Dime]} when three quarters are added and candy is selected' do
                vendingMachine.accept_coin Quarter.new
                output = vendingMachine.select_product 'candy'
                expect(output[:change].length).to eq 1
                expect(output[:change][0].instance_of? Dime).to eq true
            end
        end
    end
end
