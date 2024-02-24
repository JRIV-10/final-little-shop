require "rails_helper"

RSpec.describe Merchant, type: :model do
  describe "validations" do
    it { should validate_presence_of :name}
  end

  describe "relationships" do
    it {should have_many :items}
  end

  before(:each) do
    @merchant_1 = create(:merchant)

    @customer_1 = create(:customer)
    @customer_2 = create(:customer)
    @customer_3 = create(:customer)
    @customer_4 = create(:customer)
    @customer_5 = create(:customer)
    @customer_6 = create(:customer)

    @invoice_1 = create(:invoice, customer: @customer_1)
    @invoice_2 = create(:invoice, customer: @customer_2)
    @invoice_3 = create(:invoice, customer: @customer_3)
    @invoice_4 = create(:invoice, customer: @customer_4)
    @invoice_5 = create(:invoice, customer: @customer_5)
    @invoice_6 = create(:invoice, customer: @customer_6)

    @transactions_1 = create(:transaction, invoice: @invoice_1)
    @transactions_2 = create(:transaction, invoice: @invoice_2)
    @transactions_3 = create(:transaction, invoice: @invoice_3)
    @transactions_4 = create(:transaction, invoice: @invoice_4)
    @transactions_5 = create(:transaction, invoice: @invoice_5)
    @transactions_6 = create(:transaction, invoice: @invoice_6)

    @item_1 = create(:item, merchant: @merchant_1)

    create(:invoice_item, invoice_id: @invoice_1.id, item_id: @item_1.id)
    create(:invoice_item, invoice_id: @invoice_2.id, item_id: @item_1.id)
    create(:invoice_item, invoice_id: @invoice_3.id, item_id: @item_1.id)
    create(:invoice_item, invoice_id: @invoice_4.id, item_id: @item_1.id)
    create(:invoice_item, invoice_id: @invoice_5.id, item_id: @item_1.id)
    create(:invoice_item, invoice_id: @invoice_6.id, item_id: @item_1.id)
  end
  
  describe "instance methods" do
    describe "#top_five_customers" do
      it "should return the top five customers with the most successful transactions" do
        customers = [@customer_1, @customer_2, @customer_3, @customer_4, @customer_5]

        top_five_customers = @merchant_1.top_five_customers.map { |customer| Customer.find(customer.id) }

        expect(top_five_customers).to eq(customers)
      end
    end
  end
end
