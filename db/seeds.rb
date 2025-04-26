# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Skip AdminUser creation if it already exists
unless defined?(AdminUser) && AdminUser.find_by(email: 'admin@example.com')
  AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development? && defined?(AdminUser)
end

# Skip User creation if an admin already exists
admin_exists = User.where(admin: true).exists?
unless admin_exists
  if User.find_by(email: 'site_admin@example.com').nil?
    User.create!(
      email: 'site_admin@example.com',
      password: 'password123',
      password_confirmation: 'password123',
      first_name: 'Admin',
      last_name: 'User',
      phone: '204-555-1234',
      admin: true
    )
    puts 'Admin user created!'
  else
    puts 'Admin user already exists!'
  end
end

# Test Users (only create if we have fewer than 6 users)
if User.count < 6
  existing_emails = User.pluck(:email)
  5.times do |i|
    test_email = "user#{i+1}@example.com"
    unless existing_emails.include?(test_email)
      User.create!(
        email: test_email,
        password: 'password123',
        password_confirmation: 'password123',
        first_name: "First#{i+1}",
        last_name: "Last#{i+1}",
        phone: "204-555-#{1235+i}",
        admin: false
      )
      puts "Created test user: #{test_email}"
    end
  end
end

# Create Product Categories
if Category.count == 0
  categories = [
    { name: 'Golf Apparel', description: 'High-performance golf clothing for the modern golfer.' },
    { name: 'Golf Accessories', description: 'Essential accessories for your game.' },
    { name: 'Golf Bags', description: 'Stylish and functional golf bags.' },
    { name: 'Golf Shoes', description: 'Performance footwear for the course.' },
    { name: 'Streetwear', description: 'Golf-inspired streetwear for everyday style.' }
  ]

  categories.each do |category|
    Category.create!(category)
  end
  puts "#{categories.length} categories created!"
end

# Create Products
if Product.count == 0
  apparel_category = Category.find_by(name: 'Golf Apparel')
  accessories_category = Category.find_by(name: 'Golf Accessories')

  products = [
    {
      name: 'Performance Polo',
      description: 'Moisture-wicking polo shirt for maximum comfort on the course.',
      category: apparel_category,
      sku: 'POLO-001',
      stock_quantity: 25
    },
    {
      name: 'Weather-Resistant Hoodie',
      description: 'Stay warm and dry with this stylish hoodie designed for golf in variable conditions.',
      category: apparel_category,
      sku: 'HOOD-001',
      stock_quantity: 15
    },
    {
      name: 'Premium Golf Glove',
      description: 'Superior grip and comfort with genuine leather construction.',
      category: accessories_category,
      sku: 'GLOVE-001',
      stock_quantity: 40
    }
  ]

  products.each do |product|
    Product.create!(product)
  end
  puts "#{products.length} products created!"
end
