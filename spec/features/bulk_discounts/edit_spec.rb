require 'rails_helper'

RSpec.describe 'Edit Page', type: :feature do
  describe 'As a Merchant' do
    before(:each) do
      @merchant_1 = Merchant.create!(name: "Barry")
      @discount_1 = @merchant_1.bulk_discounts.create!(discount: 10, quantity: 5)
      @discount_2 = @merchant_1.bulk_discounts.create!(discount: 9, quantity: 3)
    end
    describe "US-5" do
      it 'can edit the discount information' do
        visit edit_merchant_bulk_discount_path(@merchant_1, @discount_1)
        # And I see that the discounts current attributes are pre-poluated in the form
        # save_and_open_page
        expect(page.find_field("Discount").value).to have_content("10")
        expect(page.find_field("Quantity").value).to have_content("5")
        
        # When I change any/all of the information and click submit
        fill_in("Discount", with: 20)
        fill_in("Quantity", with: 10)
        click_on("Update Bulk discount")
        # Then I am redirected to the bulk discount's show page
        expect(current_path).to eq(merchant_bulk_discount_path(@merchant_1, @discount_1))
        # And I see that the discount's attributes have been updated
        expect(page).to have_content("20")
        expect(page).to have_content("10")
      end
    end
  end
end