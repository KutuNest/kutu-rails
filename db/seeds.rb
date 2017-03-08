# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Countries
{ "Malaysia" => 'MY',
  "Indonesia" => 'ID',
  "Singapore" => 'SG',
  "Philippines" => 'PH',
  "Thailand" => 'TH',
  "Brunei Darussalam" => 'BN' 
}.each do |t|
  c = Country.new
  c.title = t.first
  c.tld = t.last
  if c.save
    puts "Country: #{c.title} saved"
  else
    puts "Country: #{c.title} error - #{c.errors.to_a.first}"
  end
end

# Banks
[
  "Affin Bank",
  "Alliance Bank",
  "Al Rajhi Bank",
  "AmBank",
  "Bank Islam",
  "Bank Muamalat",
  "BSN",
  "CIMB",
  "Citibank",
  "HSBC",
  "Hong Leong Bank",
  "Kuwait Finance",
  "Maybank",
  "OCBC",
  "Public Bank",
  "RHB",
  "Standard Chartered",
  "UOB"
].each do |t|
  b = Bank.new
  b.title = t
  if b.save
    puts "Bank: #{b.title} saved"
  else
    puts "Bank: #{b.title} error - #{b.errors.to_a.first}"
  end  
end