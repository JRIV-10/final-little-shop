require "rails_helper"

RSpec.describe "Admin Invoices Show", type: :feature do
  describe "As a admin" do
    before do
      @merchant_1 = create(:merchant)

      @item_1 = create(:item, name: "shoes", merchant: @merchant_1)
      @item_2 = create(:item, name: "book", merchant: @merchant_1)
      @item_3 = create(:item, name: "lamp", merchant: @merchant_1)

      @customer_1 = Customer.create!(first_name: "Lance", last_name: "B")
      @customer_2 = Customer.create!(first_name: "Jess", last_name: "K")

      @invoice_1 = @customer_1.invoices.create!(status: 1, created_at: "2011-09-13")
      @invoice_2 = @customer_2.invoices.create!(status: 2, created_at: "2022-03-08")

      @invoice_item_1 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_1.id, quantity: 1, unit_price: 2500, status: 0) # pending
      @invoice_item_2 = InvoiceItem.create!(item_id: @item_2.id, invoice_id: @invoice_1.id, quantity: 2, unit_price: 1000, status: 1) # packaged
      @invoice_item_3 = InvoiceItem.create!(item_id: @item_3.id, invoice_id: @invoice_1.id, quantity: 3, unit_price: 5000, status: 2) # shipped

      @discount = @merchant_1.bulk_discounts.create!(discount: 20, quantity: 3)
      visit admin_invoice_path(@invoice_1)
    end

    describe "User Story 33 - Admin Invoice Show page" do
      it "list invoice attributes" do
        expect(page).to have_content(@invoice_1.id)
        expect(page.find_field("Status").value).to eq("Completed")
        expect(page).to have_content("Tuesday, September 13, 2011")
        expect(page).to_not have_content(@invoice_2.id)
        expect(page.find_field("Status").value).to_not eq("Cancelled")
        expect(page).to_not have_content("Tuesday, March 08, 2022")
      end

      it "has customers first and last name" do
        expect(page).to have_content("Lance B")
        expect(page).to_not have_content("Jess K")
      end
    end

    describe "User Story 34 - Invoice Item Information" do
      it "lists invoice's items and their info" do
        within "#invoice_item-#{@invoice_item_1.id}" do
          expect(page).to have_content("shoes")
          expect(page).to have_content("1")
          expect(page).to have_content("$25.00")
          expect(page).to have_content("Pending")
        end

        within "#invoice_item-#{@invoice_item_2.id}" do
          expect(page).to have_content("book")
          expect(page).to have_content("2")
          expect(page).to have_content("$10.00")
          expect(page).to have_content("Packaged")
        end

        within "#invoice_item-#{@invoice_item_3.id}" do
          expect(page).to have_content("lamp")
          expect(page).to have_content("3")
          expect(page).to have_content("$50.00")
          expect(page).to have_content("Shipped")
        end
      end
    end

    describe "User Story 35 - Invoice's Total Revenue" do
      it "displays total revenue to be made from this invoice" do
        expect(page).to have_content("Total Revenue: $195.00")
      end
    end

    describe "User Story 36 - Update Invoice Status" do
      it "displays current status in a 'select' field" do
        expect(page).to have_select("Status", with_options: ["In Progress", "Completed", "Cancelled"])
        expect(page.find_field("Status").value).to eq("Completed")
      end

      it "updates invoice status and reloads show page" do
        select "In Progress", from: "Status"
        click_button "Update Invoice"

        expect(current_path).to eq(admin_invoice_path(@invoice_1))
        expect(page.find_field("Status").value).to eq("In Progress")
      end

      describe "US-8 Admin Invoice Show Page: Total Revenue and Discounted Revenue" do 
        it "displays discounted revenue" do 
          # When I visit an admin invoice show page
          # Then I see the total revenue from this invoice (not including discounts)
          expect(page).to have_content("Total Revenue: $195.00")
    
          # And I see the total discounted revenue from this invoice which includes bulk discounts in the calculation
          expect(page).to have_content("Discounted Revenue: $165.00")
        end
      end
    end
  end
end
