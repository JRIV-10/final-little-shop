require "rails_helper"

RSpec.describe InvoiceItem, type: :model do
  describe "validations" do
    it { should validate_presence_of :quantity}
    it { should validate_numericality_of :quantity}

    it { should validate_presence_of :unit_price}
    it { should validate_numericality_of :unit_price}
    
    it { should validate_presence_of :status}
    it { should define_enum_for(:status).with_values("Pending" => 0, "Packaged" => 1, "Shipped" => 2)}
  end
  
  describe "relationships" do
    it {should belong_to :invoice}
    it {should belong_to :item}
  end

  before do
    @merchant_1 = create(:merchant)
    @item_1 = create(:item, merchant: @merchant_1)
    @item_2 = create(:item, merchant: @merchant_1)
    @customer_1 = create(:customer)
    @invoice_1 = create(:invoice, customer: @customer_1)
    @invoice_2 = create(:invoice, customer: @customer_1)
    @invoice_item_1 = create(:invoice_item, item: @item_1, invoice: @invoice_1, unit_price: 500, quantity: 10)
    @invoice_item_2 = create(:invoice_item, item: @item_2, invoice: @invoice_2, unit_price: 1027, quantity: 2)
    @discount = @merchant_1.bulk_discounts.create!(discount: 20, quantity: 10)
  end

  describe "instance methods" do
    it "formats unit_price sold at" do
      expect(@invoice_item_1.format_unit_price).to eq("$5.00")
      expect(@invoice_item_2.format_unit_price).to eq("$10.27")
    end

    describe "#bulk_discount" do 
      it "finds if a discount is applied" do 
        expect(@invoice_item_1.bulk_discount).to eq(@discount)
        expect(@invoice_item_2.bulk_discount).not_to eq(@discount)
      end
    end
  end
end