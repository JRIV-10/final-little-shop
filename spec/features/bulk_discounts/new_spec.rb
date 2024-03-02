require 'rails_helper'

RSpec.describe 'New Page', type: :feature do
  describe 'As a Merchant' do
    before(:each) do
      @merchant_1 = Merchant.create!(name: "Barry")
      @discount_1 = @merchant_1.bulk_discounts.create!(discount: 10, quantity: 5)  
    end

    describe "US-2 Merchant Bulk Discount Create" do 
      it 'Has a form to add a new bulk discount' do
        visit merchant_bulk_discounts_path(@merchant_1)

        within '#discounts' do
          expect(page).not_to have_content(20)
          expect(page).not_to have_content(12)
        end
        # Then I am taken to a new page where I see a form to add a new bulk discount
        visit (new_merchant_bulk_discount_path(@merchant_1))

        expect(page).to have_content("Discount")
        expect(page).to have_content("Qauntity")
        # When I fill in the form with valid data
        fill_in "Discount", with: "20"
        fill_in "Qauntity", with: "12"
        click_on "Submit"
        
        # Then I am redirected back to the bulk discount index
        expect(current_path).to eq(merchant_bulk_discounts_path(@merchant_1))
        expect(page).to have_content("Succesfully Created a New Discount")
        # And I see my new bulk discount listed
        expect(page).to have_content(20)
        expect(page).to have_content(12)
      end

      #sad path testing 
      it "has an error message if not all fields are filled in" do 
        visit new_merchant_bulk_discount_path(@merchant_1)

        fill_in("Discount", with: 20)
        fill_in("Qauntity", with: "")
        click_button "Submit"

        expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant_1))
        expect(page).to have_content("Please fill in ALL required fields")
      end
    end
  end
end