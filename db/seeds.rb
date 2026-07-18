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

  Product.find_or_create_by!(slug: "es-teh-manis") do |product|
    product.name = "Es Teh Manis"
    product.category = minuman
    product.description = "Teh manis segar dengan es batu."
    product.price_cents = 5_000
    product.stock = 50
  end

  Product.find_or_create_by!(slug: "keripik-singkong") do |product|
    product.name = "Keripik Singkong"
    product.category = camilan
    product.description = "Keripik singkong renyah rasa original."
    product.price_cents = 12_000
    product.stock = 30
  end
end

puts "Seed selesai. Login admin: #{admin_email} / #{admin_password}"
