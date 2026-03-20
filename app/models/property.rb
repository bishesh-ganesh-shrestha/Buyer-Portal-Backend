class Property < ApplicationRecord
  has_many :favourites, dependent: :destroy
  has_many :users, through: :favourites

  validates :title, presence: true
  validates :address, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :bedrooms, numericality: { greater_than_or_equal_to: 0 }
  validates :bathrooms, numericality: { greater_than_or_equal_to: 0 }
  validates :property_type, presence: true
end
