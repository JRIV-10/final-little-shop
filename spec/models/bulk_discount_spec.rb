require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do
  describe "relationships" do 
    it {should belong_to :merchant}
  end

  describe "validations" do 
    it {should validate_presence_of :discount}
    it {should validate_presence_of :quantity}
  end
end
