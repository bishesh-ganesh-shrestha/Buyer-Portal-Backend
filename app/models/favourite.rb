class Favourite < ApplicationRecord
  belongs_to :user
  belongs_to :property

  validates :user_id, uniqueness: { scope: :property_id,
                      message: "already has this property in favourites" }
end
