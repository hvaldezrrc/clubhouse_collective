# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

# Admin User
if User.find_by(email: 'admin@example.com').nil?
  User.create!(
    email: 'admin@example.com',
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

# Test User
if User.count == 1
  5.times do |i|
    User.create!(
      email: "user#{i+1}@example.com",
      password: 'password123',
      password_confirmation: 'password123',
      first_name: "First#{i+1}",
      last_name: "Last#{i+1}",
      phone: "204-555-#{1235+i}",
      admin: false
    )
  end
  puts '5 regular users created!'
end
