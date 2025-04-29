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

# Create products and categories
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

if Product.count < 10
  apparel_category = Category.find_by(name: 'Golf Apparel')
  accessories_category = Category.find_by(name: 'Golf Accessories')
  bags_category = Category.find_by(name: 'Golf Bags')
  shoes_category = Category.find_by(name: 'Golf Shoes')
  streetwear_category = Category.find_by(name: 'Streetwear')

  products = [
    {
      name: 'Performance Polo',
      description: 'Moisture-wicking polo shirt designed for maximum comfort on the course. Features a breathable fabric that keeps you cool during hot rounds and anti-odor technology to stay fresh all day. Available in multiple colors to match any outfit.',
      category: apparel_category,
      sku: 'POLO-001',
      stock_quantity: 25
    },
    {
      name: 'Weather-Resistant Hoodie',
      description: 'Stay warm and dry with this stylish hoodie designed for golf in variable conditions. Water-resistant outer layer with a soft fleece interior provides comfort without compromising your swing. Includes zippered pockets to secure your valuables.',
      category: apparel_category,
      sku: 'HOOD-001',
      stock_quantity: 15
    },
    {
      name: 'Premium Golf Glove',
      description: 'Superior grip and comfort with genuine Cabretta leather construction. Perforated design enhances breathability while strategic padding reduces hand fatigue during long rounds. Machine washable for extended durability.',
      category: accessories_category,
      sku: 'GLOVE-001',
      stock_quantity: 40
    },
    {
      name: 'Lightweight Stand Bag',
      description: 'Ultra-lightweight stand bag weighing only 4.5 pounds with dual-strap system for comfortable carrying. Features 7 pockets including a velour-lined valuables pocket, full-length dividers, and a built-in stand mechanism with non-slip foot pads.',
      category: bags_category,
      sku: 'BAG-001',
      stock_quantity: 12
    },
    {
      name: 'Tour Performance Hat',
      description: 'Structured front panel hat with moisture-wicking sweatband and UV protection. The breathable mesh back panels keep you cool while the adjustable snapback ensures perfect fit for any head size.',
      category: apparel_category,
      sku: 'HAT-001',
      stock_quantity: 30
    },
    {
      name: 'Spikeless Golf Shoes',
      description: 'Modern spikeless golf shoes offering exceptional traction and stability. Features a waterproof membrane, cushioned midsole for all-day comfort, and a classic design that transitions seamlessly from course to clubhouse.',
      category: shoes_category,
      sku: 'SHOE-001',
      stock_quantity: 20
    },
    {
      name: 'Golf-Inspired Crewneck',
      description: 'Streetwear-inspired crewneck featuring embroidered golf designs. Made from premium cotton blend for exceptional softness and durability. Relaxed fit with ribbed cuffs and hemline for a modern silhouette.',
      category: streetwear_category,
      sku: 'CREW-001',
      stock_quantity: 22
    },
    {
      name: 'Rangefinder with Slope',
      description: 'Advanced laser rangefinder with slope-adjusted distance measurements. Accurate to within 1 yard, vibration confirmation when locked on flag, 6x magnification, and waterproof construction. Tournament legal with slope function disabled.',
      category: accessories_category,
      sku: 'RANGE-001',
      stock_quantity: 8
    },
    {
      name: 'Premium Golf Umbrella',
      description: 'Oversized 68-inch golf umbrella with double-canopy design to withstand strong winds. UV protection coating, ergonomic grip handle, and automatic open function. Branded with the Clubhouse Collective logo.',
      category: accessories_category,
      sku: 'UMB-001',
      stock_quantity: 15
    },
    {
      name: 'Cart Bag with Cooler Pocket',
      description: 'Fully-featured cart bag with 15-way top divider system and dedicated putter well. Includes insulated cooler pocket, 9 additional pockets, integrated trunk handle, and cart strap channel for secure attachment.',
      category: bags_category,
      sku: 'CBAG-001',
      stock_quantity: 10
    },
    {
      name: 'Golf Course Joggers',
      description: 'Performance joggers blending athletic functionality with street style. Four-way stretch fabric allows for unrestricted movement during your swing while tapered legs and cuffed ankles create a modern look that transitions from course to casual settings.',
      category: streetwear_category,
      sku: 'JOG-001',
      stock_quantity: 18
    },
    {
      name: 'Classic Visor',
      description: 'Lightweight tour visor with high-quality embroidered logo. Features a moisture-wicking sweatband and adjustable velcro closure for custom fit. Perfect for keeping the sun out of your eyes while allowing heat to escape.',
      category: apparel_category,
      sku: 'VIS-001',
      stock_quantity: 25
    }
  ]

  existing_skus = Product.pluck(:sku)
  products_to_create = products.reject { |p| existing_skus.include?(p[:sku]) }

  products_to_create.each do |product|
    Product.create!(product)
  end
  puts "#{products_to_create.length} products created!"
end

if Product.count < 100
  puts "Seeding 100+ random products..."

  categories = Category.all

  100.times do
    category = categories.sample
    base_names = {
      'Golf Apparel' => [ 'Polo Shirt', 'Quarter Zip Pullover', 'Sun Hoodie', 'Rain Jacket', 'Performance Shorts' ],
      'Golf Accessories' => [ 'Golf Glove', 'Divot Tool', 'Ball Marker', 'Golf Towel', 'Scorecard Holder' ],
      'Golf Bags' => [ 'Stand Bag', 'Cart Bag', 'Tour Staff Bag', 'Sunday Bag', 'Travel Cover' ],
      'Golf Shoes' => [ 'Spikeless Shoes', 'Tour Cleats', 'Waterproof Shoes', 'Performance Shoes', 'Casual Golf Shoes' ],
      'Streetwear' => [ 'Crewneck Sweatshirt', 'Golf Joggers', 'Snapback Hat', 'Bomber Jacket', 'Athletic Shorts' ]
    }

    base_product_name = base_names[category.name].sample
    gender_prefix = [ 'Men\'s', 'Women\'s', 'Unisex' ].sample
    material_prefix = [ 'Performance', 'Lightweight', 'Classic', 'Tour', 'Elite' ].sample

    product_name = "#{gender_prefix} #{material_prefix} #{base_product_name}"

    Product.create!(
      name: product_name,
      description: Faker::Lorem.paragraph(sentence_count: 5),
      sku: Faker::Alphanumeric.alphanumeric(number: 8).upcase,
      stock_quantity: rand(5..50),
      category: category
    )
  end

  puts "Random products created!"
end

# Add static pages
unless StaticPage.exists?(slug: 'about')
  StaticPage.create!(
    title: 'About Clubhouse Collective',
    slug: 'about',
    content: 'Clubhouse Collective is an e-commerce store specializing in merging golf and streetwear, offering high-performance golf apparel, stylish and functional accessories, and gear designed for the modern golfer. Founded 3 years ago out of a passion for both the game of golf and the unique culture surrounding it, our focus is on combining traditional golfing essentials with contemporary, street-inspired style.'
  )
  puts "About page created!"
end

unless StaticPage.exists?(slug: 'contact')
  StaticPage.create!(
    title: 'Contact Us',
    slug: 'contact',
    content: "### We'd love to hear from you!\n\nPhone: (204) 555-1234\n\nEmail: info@clubhousecollective.com\n\n### Hours of Operation\nMonday - Friday: 9am - 5pm EST\nSaturday: 10am - 4pm EST\nSunday: Closed\n\n### Location\nOur products are available exclusively online, but we're always happy to assist you via phone or email."
  )
  puts "Contact page created!"
end

# Provinces with tax rates
provinces_data = [
  { name: 'Alberta', code: 'AB', gst: 0.05, pst: 0.00, hst: 0.00 },
  { name: 'British Columbia', code: 'BC', gst: 0.05, pst: 0.07, hst: 0.00 },
  { name: 'Manitoba', code: 'MB', gst: 0.05, pst: 0.07, hst: 0.00 },
  { name: 'New Brunswick', code: 'NB', gst: 0.00, pst: 0.00, hst: 0.15 },
  { name: 'Newfoundland and Labrador', code: 'NL', gst: 0.00, pst: 0.00, hst: 0.15 },
  { name: 'Northwest Territories', code: 'NT', gst: 0.05, pst: 0.00, hst: 0.00 },
  { name: 'Nova Scotia', code: 'NS', gst: 0.00, pst: 0.00, hst: 0.15 },
  { name: 'Nunavut', code: 'NU', gst: 0.05, pst: 0.00, hst: 0.00 },
  { name: 'Ontario', code: 'ON', gst: 0.00, pst: 0.00, hst: 0.13 },
  { name: 'Prince Edward Island', code: 'PE', gst: 0.00, pst: 0.00, hst: 0.15 },
  { name: 'Quebec', code: 'QC', gst: 0.05, pst: 0.09975, hst: 0.00 },
  { name: 'Saskatchewan', code: 'SK', gst: 0.05, pst: 0.06, hst: 0.00 },
  { name: 'Yukon', code: 'YT', gst: 0.05, pst: 0.00, hst: 0.00 }
]

provinces_data.each do |province_data|
  province = Province.find_or_create_by!(
    name: province_data[:name],
    code: province_data[:code]
  )

  TaxRate.find_or_create_by!(
    province: province,
    gst: province_data[:gst],
    pst: province_data[:pst],
    hst: province_data[:hst]
  )

  puts "Created #{province.name} with tax rates: GST: #{province_data[:gst]}, PST: #{province_data[:pst]}, HST: #{province_data[:hst]}"
end
