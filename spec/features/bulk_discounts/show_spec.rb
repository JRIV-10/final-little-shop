require 'rails_helper'

RSpec.describe 'Show Page', type: :feature do
  describe 'As a Merchant' do
    before(:each) do
      @merchant_1 = Merchant.create!(name: "Barry")
      @discount_1 = @merchant_1.bulk_discounts.create!(discount: 10, quantity: 5)
      @discount_2 = @merchant_1.bulk_discounts.create!(discount: 9, quantity: 3)
    end
    
    describe "US-4 Merchant Bulk Discount Show" do
      it 'displays discount percent and quantity' do
        # When I visit my bulk discount show page
        visit merchant_bulk_discount_path(@merchant_1, @discount_1)
        # Then I see the bulk discount's quantity threshold and percentage discount
        expect(page).to have_content(@discount_1.discount)
        expect(page).to have_content(@discount_1.quantity)
      end
    end
  end
end