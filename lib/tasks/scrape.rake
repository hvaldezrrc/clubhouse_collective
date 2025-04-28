namespace :scrape do
  desc "Scrape golf equipment from Golf Digest"
  task golf_digest: :environment do
    require "nokogiri"
    require "open-uri"

    puts "Starting to scrape from Golf Digest..."

    url = "https://www.golfdigest.com/hot-list"

    begin
      doc = Nokogiri::HTML(URI.open(url))

      categories = {
        "Drivers" => "Premium golf drivers for maximum distance",
        "Irons" => "Precision irons for accuracy and control",
        "Putters" => "Balanced putters for a true roll",
        "Golf Accessories" => "Essential accessories for your game"
      }

      category_objects = {}
      categories.each do |name, desc|
        category_objects[name] = Category.find_or_create_by!(name: name) do |c|
          c.description = desc
        end
      end

      products = doc.css(".hot-list-item")

      products.each_with_index do |product_el, index|
        name_el = product_el.css(".hot-list-item-name")
        name = name_el.text.strip

        next if name.empty?

        category_name = if name.downcase.include?("driver")
                         "Drivers"
        elsif name.downcase.include?("iron") || name.downcase.include?("wedge")
                         "Irons"
        elsif name.downcase.include?("putter")
                         "Putters"
        else
                         "Golf Accessories"
        end

        sku = "#{category_name[0..2].upcase}-#{100 + index}"

        unless Product.exists?(name: name)
          product = Product.new(
            name: name,
            description: "High-quality #{name} for serious golfers. Part of the Golf Digest Hot List.",
            category: category_objects[category_name],
            sku: sku,
            stock_quantity: rand(10..50)
          )

          if product.save
            puts "Created product: #{name}"
          else
            puts "Failed to create product: #{product.errors.full_messages.join(', ')}"
          end
        else
          puts "Product '#{name}' already exists, skipping."
        end
      end

      puts "Golf Digest scraping completed!"
    rescue => e
      puts "Error scraping Golf Digest: #{e.message}"
    end
  end
end
