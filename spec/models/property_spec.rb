require 'rails_helper'

RSpec.describe Property, type: :model do
  describe 'associations' do
    it { should have_many(:favourites).dependent(:destroy) }
    it { should have_many(:users).through(:favourites) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:address) }
    it { should validate_presence_of(:price) }
    it { should validate_presence_of(:property_type) }
    it { should validate_numericality_of(:price).is_greater_than(0) }
    it { should validate_numericality_of(:bedrooms).is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:bathrooms).is_greater_than_or_equal_to(0) }
  end
end
