require 'rails_helper'

RSpec.describe 'Merchant Invoices Show Page', type: :feature do
  describe 'As a Merchant ' do
    before(:each) do
      @yain = Customer.create!(first_name: "Yain", last_name: "Porter")
      @abdul = Customer.create!(first_name: "Abdul", last_name: "R")

      @merchant_1 = Merchant.create!(name: "Barry")
      @item_1 = create(:item, name: "book", merchant: @merchant_1)
      @item_2 = create(:item, name: "belt", merchant: @merchant_1)

      @invoice_1 = Invoice.create!(customer_id: @yain.id, status: 1, created_at: "2011-09-13")

      @invoice_item_1 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_1.id, quantity: 1, unit_price: 2500, status: 0) # pending
      @invoice_item_2 = InvoiceItem.create!(item_id: @item_2.id, invoice_id: @invoice_1.id, quantity: 2, unit_price: 1000, status: 1) # packaged
      @invoice_item_3 = InvoiceItem.create!(item_id: @item_2.id, invoice_id: @invoice_1.id, quantity: 6, unit_price: 1000, status: 1) # packaged

      @merchant_2 = Merchant.create!(name: "Jane")
      @item_3 = create(:item, name: "soda", merchant: @merchant_2)
      @item_4 = create(:item, name: "shoe", merchant: @merchant_2)

      @invoice_2 = Invoice.create!(customer_id: @abdul.id, status: 0, created_at: "2011-09-14")

      @invoice_item_4 = InvoiceItem.create!(item_id: @item_3.id, invoice_id: @invoice_2.id, quantity: 2, unit_price: 1000, status: 1) # packaged

      visit merchant_invoice_path(@merchant_1, @invoice_1)
    end

    describe "User Story 15 - Listing Invoice Attributes" do
      it "displays all the information related to the Invoice" do
        expect(page).to have_content("Invoice ##{@invoice_1.id}")
        expect(page).to have_content("Status: Completed")
        expect(page).to have_content("Created on: Tuesday, September 13, 2011")
        expect(page).to have_content("Customer: Yain Porter")

        visit merchant_invoice_path(@merchant_2, @invoice_2)

        expect(page).to have_content("Invoice ##{@invoice_2.id}")
        expect(page).to have_content("Status: In Progress")
        expect(page).to have_content("Created on: Wednesday, September 14, 2011")
        expect(page).to have_content("Customer: Abdul R")
      end
    end

    describe "User Story 16 - Invoice Item Information" do
      it "lists all items on the invoice" do
        expect(page).to have_content("Item Name")
        expect(page).to have_content("Quantity")
        expect(page).to have_content("Unit Price")
        expect(page).to have_content("Status")

        within "#invoice_item-#{@invoice_item_1.id}" do
          expect(page).to have_content("book")
          expect(page).to have_content("1")
          expect(page).to have_content("$25.00")
          expect(page).to have_content("Pending")
        end

        within "#invoice_item-#{@invoice_item_2.id}" do
          expect(page).to have_content("belt")
          expect(page).to have_content("2")
          expect(page).to have_content("$10.00")
          expect(page).to have_content("Packaged")
        end

        visit merchant_invoice_path(@merchant_2, @invoice_2)

        within "#invoice_item-#{@invoice_item_4.id}" do
          expect(page).to have_content("soda")
          expect(page).to have_content("2")
          expect(page).to have_content("$10.00")
          expect(page).to have_content("Packaged")
        end
      end
    end

    describe "User Story 17 - Total Revenue" do
      it "displays the total revenue generated from all items" do
        expect(page).to have_content("Total Revenue: $105.00")

        visit merchant_invoice_path(@merchant_2, @invoice_2)

        expect(page).to have_content("Total Revenue: $20.00")
      end
    end

    describe "User Story 18 - Update Item Status" do
      it "displays a select field with current status selected for Items" do
        within "#invoice_item-#{@invoice_item_1.id}" do
          expect(page).to have_select("Status", with_options: ["Pending", "Packaged", "Shipped"])
          expect(page.find_field("Status").value).to eq("Pending")
        end

        within "#invoice_item-#{@invoice_item_2.id}" do
          expect(page).to have_select("Status", with_options: ["Pending", "Packaged", "Shipped"])
          expect(page.find_field("Status").value).to eq("Packaged")
        end
      end

      it "updates each Item's status when I click Submit" do
        within "#invoice_item-#{@invoice_item_1.id}" do
          expect(page.find_field("Status").value).to_not eq("Shipped")

          select "Shipped", from: "Status"
          click_button

          expect(page.current_path).to eq(merchant_invoice_path(@merchant_1.id, @invoice_1))
          expect(page.find_field("Status").value).to eq("Shipped")
        end

        within "#invoice_item-#{@invoice_item_2.id}" do
          expect(page.find_field("Status").value).to_not eq("Pending")

          select "Pending", from: "Status"
          click_button

          expect(page.current_path).to eq(merchant_invoice_path(@merchant_1.id, @invoice_1))
          expect(page.find_field("Status").value).to eq("Pending")
        end
      end
    end
  end
  describe "US-6 Merchant Invoice Show Page: Total Revenue and Discounted Revenue" do 
    it "displays the discounted revenue" do 
      yain = Customer.create!(first_name: "Yain", last_name: "Porter")
      abdul = Customer.create!(first_name: "Abdul", last_name: "R")

      merchant = Merchant.create!(name: "Barry")
      item_1 = create(:item, name: "book", merchant: merchant)
      item_2 = create(:item, name: "belt", merchant: merchant)
      invoice_1 = Invoice.create!(customer_id: yain.id, status: 1, created_at: "2011-09-13")

      invoice_item_1 = InvoiceItem.create!(item_id: item_1.id, invoice_id: invoice_1.id, quantity: 1, unit_price: 2500, status: 0) # pending
      invoice_item_2 = InvoiceItem.create!(item_id: item_2.id, invoice_id: invoice_1.id, quantity: 2, unit_price: 1000, status: 1) # packaged
      invoice_item_3 = InvoiceItem.create!(item_id: item_2.id, invoice_id: invoice_1.id, quantity: 6, unit_price: 1000, status: 1) # package

      discount = merchant.bulk_discounts.create!(discount: 20, quantity: 5)
      # When I visit my merchant invoice show page
      visit merchant_invoice_path(merchant, invoice_1)
      # Then I see the total revenue for my merchant from this invoice (not including discounts)
      expect(page).to have_content("Total Revenue: $105.00")
      # And I see the total discounted revenue for my merchant from this invoice which includes bulk discounts in the calculation
      expect(page).to have_content("Discounted Revenue: $93")
    end
  end
end
