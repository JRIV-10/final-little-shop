FactoryBot.define do
  factory :bulk_discount do
    merchant { nil }
    quantity { 1 }
    discount { 1 }
  end
end
