class AddImageUrlToProperties < ActiveRecord::Migration[8.1]
  def change
    add_column :properties, :image_url, :string
  end
end
