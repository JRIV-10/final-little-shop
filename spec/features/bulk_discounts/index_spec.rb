require 'rails_helper'

RSpec.describe 'Index Page', type: :feature do
  describe "As a Merchant" do
    before(:each) do
    @merchant_1 = Merchant.create!(name: "Barry")
    @discount_1 = @merchant_1.bulk_discounts.create!(discount: 10, quantity: 5)
    @discount_2 = @merchant_1.bulk_discounts.create!(discount: 9, quantity: 3)
    end

    describe "Us-1 Merchant Bulk Discounts Index" do 
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

    describe "US-2 Merchant Bulk Discount Create" do
      it  "Has links to create a new discount" do 
        # When I visit my bulk discounts index
        visit merchant_bulk_discounts_path(@merchant_1)
        # Then I see a link to create a new discount
        expect(page).to have_content("Create A New Discount")
        # When I click this link
        click_on("Create A New Discount")
        expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant_1))
      end 
    end

    describe "US-3 Merchant Bulk Discount Delete" do 
      it "deletes a discount for a merchant" do 
      # When I visit my bulk discounts index
      visit merchant_bulk_discounts_path(@merchant_1)
      # Then next to each bulk discount I see a button to delete it
      expect(page).to have_button("Delete")
      # When I click this button
      within "#discount-#{@discount_2.id}" do
        click_button("Delete")
        expect(current_path).to eq(merchant_bulk_discounts_path(@merchant_1))
      end
      # Then I am redirected back to the bulk discounts index page
      # And I no longer see the discount listed
      expect(page).not_to have_content("9%")
      expect(page).not_to have_content("For orders 3 or above!")
      end
    end
  end
end