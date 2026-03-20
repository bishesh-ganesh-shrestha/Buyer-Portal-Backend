# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Clear existing data
Favourite.destroy_all
Property.destroy_all
User.destroy_all

# Create sample users
buyer = User.create!(
  name: 'Bishesh Shrestha',
  email: 'bishesh@gmail.com',
  password: 'password123',
  role: 'buyer'
)

admin = User.create!(
  name: 'Admin User',
  email: 'admin@gmail.com',
  password: 'password123',
  role: 'admin'
)

# Create sample properties
properties = Property.create!([
  {
    title: 'Modern Apartment in Lazimpat',
    address: 'Lazimpat, Kathmandu',
    price: 15000000,
    bedrooms: 3,
    bathrooms: 2,
    area_sqft: 1200,
    property_type: 'Apartment',
    description: 'A beautiful modern apartment in the heart of Kathmandu.'
  },
  {
    title: 'Luxury Villa in Budhanilkantha',
    address: 'Budhanilkantha, Kathmandu',
    price: 45000000,
    bedrooms: 5,
    bathrooms: 4,
    area_sqft: 4500,
    property_type: 'Villa',
    description: 'Spacious luxury villa with mountain views.'
  },
  {
    title: 'Cozy Flat in Patan',
    address: 'Patan, Lalitpur',
    price: 8500000,
    bedrooms: 2,
    bathrooms: 1,
    area_sqft: 850,
    property_type: 'Flat',
    description: 'Affordable and cozy flat close to Patan Durbar Square.'
  },
  {
    title: 'Commercial Space in New Baneshwor',
    address: 'New Baneshwor, Kathmandu',
    price: 25000000,
    bedrooms: 0,
    bathrooms: 2,
    area_sqft: 2000,
    property_type: 'Commercial',
    description: 'Prime commercial space in a busy business district.'
  },
  {
    title: 'Family Home in Bhaisepati',
    address: 'Bhaisepati, Lalitpur',
    price: 18000000,
    bedrooms: 4,
    bathrooms: 3,
    area_sqft: 2200,
    property_type: 'House',
    description: 'Quiet family home in a peaceful residential area.'
  }
])

puts "Seeded #{User.count} users and #{Property.count} properties"
