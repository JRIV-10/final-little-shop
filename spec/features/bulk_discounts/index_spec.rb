require 'rails_helper'

RSpec.describe 'Index Page', type: :feature do
  describe "As a Merchant" do
    before(:each) do
    @merchant_1 = Merchant.create!(name: "Barry")
    @discount_1 = @merchant_1.bulk_discounts.create!(discount: 10, quantity: 5)
    end

    # 1: Merchant Bulk Discounts Index
    it 'Has discounts with their percantage and quantity' do
      # Then I am taken to my bulk discounts index page
      visit merchant_bulk_discounts_path(@merchant_1)

      within "#discount-#{@discount_1.id}" do
        # Where I see all of my bulk discounts including their
        # percentage discount and quantity thresholds
        expect(page).to have_content("10%")
        expect(page).to have_content("For orders 5 or above!")
        # And each bulk discount listed includes a link to its show page
        click_on("I Want a Discount") 
        expect(current_path).to eq(merchant_bulk_discount_path(@merchant_1, @discount_1))
      end
    end
  end
end