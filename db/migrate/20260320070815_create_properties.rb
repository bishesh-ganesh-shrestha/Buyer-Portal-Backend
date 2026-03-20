class CreateProperties < ActiveRecord::Migration[8.1]
  def change
    create_table :properties do |t|
      t.string :title
      t.string :address
      t.integer :price
      t.integer :bedrooms
      t.integer :bathrooms
      t.integer :area_sqft
      t.string :property_type
      t.text :description

      t.timestamps
    end
  end
end
