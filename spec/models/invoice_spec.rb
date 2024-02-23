require "rails_helper"

RSpec.describe Invoice, type: :model do
  describe "validations" do
    it { should validate_presence_of :status}
    it { should define_enum_for(:status).with_values("in progress" => 0, "completed" => 1, "cancelled" => 2)}
  end

  describe "relationships" do
    it {should belong_to :customer}
    it {should have_many :invoice_items}
    it {should have_many :transactions}
    it {should have_many(:items).through(:invoice_items)}
  end

  before do
    @customer_1 = Customer.create!(first_name: "First", last_name: "Customer")

    @merchant_1 = create(:merchant)
    @items = create_list(:item, 5, merchant: @merchant_1)

    @invoice_1 = create(:invoice, customer: @customer_1)
    @invoice_2 = create(:invoice, customer: @customer_1)
    @invoice_3 = create(:invoice, customer: @customer_1)
    @invoice_4 = create(:invoice, customer: @customer_1)

    @invoice_items_1 = create(:invoice_item, invoice: @invoice_1)
    @invoice_items_2 = create(:invoice_item, invoice: @invoice_2)
    @invoice_items_3 = create(:invoice_item, status: 1, invoice: @invoice_3)
    @invoice_items_4 = create(:invoice_item, status: 2, invoice: @invoice_4)
  end

  describe "class methods" do
    describe "incomplete_invoices" do
      it "lists incomplete invoices" do
        expect(Invoice.incomplete_invoices).to eq([@invoice_1, @invoice_2, @invoice_3])

        invoice_5 = create(:invoice, customer: @customer_1)
        invoice_items_5 = create(:invoice_item, invoice: invoice_5)

        expect(Invoice.incomplete_invoices).to eq([@invoice_1, @invoice_2, @invoice_3, invoice_5])
      end

      it "lists incomplete invoices from oldest to newest" do
        expect(Invoice.incomplete_invoices).to eq([@invoice_3, @invoice_2, @invoice_1])

        invoice_5 = create(:invoice, customer: @customer_1)
        invoice_items_5 = create(:invoice_item, invoice: invoice_5)

        expect(Invoice.incomplete_invoices).to eq([@invoice_3, invoice_5, @invoice_2, @invoice_1])
      end
    end
  end
end