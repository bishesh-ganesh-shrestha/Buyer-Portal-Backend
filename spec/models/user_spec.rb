require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:favourites).dependent(:destroy) }
    it { should have_many(:properties).through(:favourites) }
  end

  describe 'validations' do
    subject { build(:user) }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_inclusion_of(:role).in_array(%w[buyer admin]) }
  end

  describe 'password' do
    it 'is secured with bcrypt' do
      user = create(:user, password: 'password123')
      expect(user.password_digest).not_to eq('password123')
    end

    it 'authenticates with correct password' do
      user = create(:user, password: 'password123')
      expect(user.authenticate('password123')).to eq(user)
    end

    it 'fails authentication with wrong password' do
      user = create(:user, password: 'password123')
      expect(user.authenticate('wrongpassword')).to be_falsey
    end
  end

  describe 'email' do
    it 'is saved in lowercase' do
      user = create(:user, email: 'BISHESH@GMAIL.COM')
      expect(user.email).to eq('bishesh@gmail.com')
    end
  end
end
