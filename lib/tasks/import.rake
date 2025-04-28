namespace :import do
  desc "Import products and categories from CSV"
  task products: :environment do
    require "csv"

    puts "Starting CSV import..."

    csv_file = Rails.root.join("lib", "assets", "data", "golf_products.csv")

    unless File.exist?(csv_file)
      puts "Error: CSV file not found at #{csv_file}"
      next
    end

    CSV.foreach(csv_file, headers: true) do |row|
      category = Category.find_or_create_by!(name: row["category"]) do |c|
        c.description = "#{row['category']} for golf enthusiasts"
      end

      unless Product.exists?(sku: row["sku"])
        product = Product.new(
          name: row["name"],
          description: row["description"],
          category: category,
          sku: row["sku"],
          stock_quantity: row["stock_quantity"]
        )

        if product.save
          puts "Created product: #{row['name']}"
        else
          puts "Failed to create product: #{product.errors.full_messages.join(', ')}"
        end
      else
        puts "Product with SKU '#{row['sku']}' already exists, skipping."
      end
    end

    puts "CSV import completed!"
  end
end
