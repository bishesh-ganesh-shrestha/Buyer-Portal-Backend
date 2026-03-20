require 'rails_helper'

RSpec.describe Favourite, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:property) }
  end

  describe 'uniqueness' do
    it 'does not allow duplicate favourites' do
      user = create(:user)
      property = create(:property)
      create(:favourite, user: user, property: property)
      duplicate = build(:favourite, user: user, property: property)
      expect(duplicate).not_to be_valid
    end

    it 'allows same property to be favourited by different users' do
      property = create(:property)
      user1 = create(:user)
      user2 = create(:user)
      create(:favourite, user: user1, property: property)
      favourite2 = build(:favourite, user: user2, property: property)
      expect(favourite2).to be_valid
    end
  end
end
