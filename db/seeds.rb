# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

admin_email = ENV.fetch("ADMIN_EMAIL", "admin@warungjajan.test")
admin_password = ENV.fetch("ADMIN_PASSWORD", "password123")

User.find_or_create_by!(email_address: admin_email) do |user|
  user.password = admin_password
end

if Rails.env.development?
  minuman = Category.find_or_create_by!(name: "Minuman")
  camilan = Category.find_or_create_by!(name: "Camilan")

  seed_products = [
    { slug: "es-teh-manis", name: "Es Teh Manis", category: minuman,
      description: "Teh manis segar dengan es batu.", price_cents: 5_000, stock: 50 },
    { slug: "es-jeruk", name: "Es Jeruk", category: minuman,
      description: "Perasan jeruk segar dengan es batu.", price_cents: 6_000, stock: 40 },
    { slug: "es-kopi-susu", name: "Es Kopi Susu", category: minuman,
      description: "Kopi susu dingin, manis dan creamy.", price_cents: 10_000, stock: 35 },
    { slug: "es-cendol", name: "Es Cendol", category: minuman,
      description: "Cendol gula merah dengan santan dan es.", price_cents: 8_000, stock: 25 },
    { slug: "keripik-singkong", name: "Keripik Singkong", category: camilan,
      description: "Keripik singkong renyah rasa original.", price_cents: 12_000, stock: 30 },
    { slug: "pisang-goreng", name: "Pisang Goreng", category: camilan,
      description: "Pisang goreng crispy, digoreng saat dipesan.", price_cents: 8_000, stock: 40 },
    { slug: "cimol", name: "Cimol", category: camilan,
      description: "Cimol kenyal dengan bumbu tabur pedas manis.", price_cents: 7_000, stock: 35 },
    { slug: "basreng", name: "Basreng", category: camilan,
      description: "Bakso goreng renyah dengan taburan cabai bubuk.", price_cents: 9_000, stock: 30 }
  ]

  seed_images = Rails.root.join("db/seed_images")

  seed_products.each do |attrs|
    slug = attrs.fetch(:slug)

    product = Product.find_or_create_by!(slug: slug) do |p|
      p.name = attrs.fetch(:name)
      p.category = attrs.fetch(:category)
      p.description = attrs.fetch(:description)
      p.price_cents = attrs.fetch(:price_cents)
      p.stock = attrs.fetch(:stock)
    end

    next if product.photo.attached?

    product.photo.attach(
      io: File.open(seed_images.join("#{slug}.png")),
      filename: "#{slug}.png",
      content_type: "image/png"
    )
  end
end

puts "Seed selesai. Login admin: #{admin_email} / #{admin_password}"
