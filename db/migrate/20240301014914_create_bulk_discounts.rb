class CreateBulkDiscounts < ActiveRecord::Migration[7.1]
  def change
    create_table :bulk_discounts do |t|
      t.references :merchant, null: false, foreign_key: true
      t.integer :quantity
      t.integer :discount

      t.timestamps
    end
  end
end
