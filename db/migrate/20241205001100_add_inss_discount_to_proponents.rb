class AddInssDiscountToProponents < ActiveRecord::Migration[7.1]
  def change
    add_column :proponents, :inss_discount, :string
  end
end
