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

# Groupement & Pool
["Default Group", "Second Group"].each do |t|
  g = Groupement.new
  g.activated_on_create = false
  g.initial_accounts = 1
  g.maximum_accounts = 100
  g.accounts_added_on_success = 8
  g.title = t
  if g.save
    puts "Group: #{g.title} saved"

    ["First Pool", "Second Pool", "Third Pool"].each_with_index do |t, i|
      p = g.pools.new
      p.title = t
      p.amount = [1000, 2000, 4000][i]
      p.position = i
      p.feeders_count = 4
      p.timeout = 60*60*24*3
      if p.save
        puts "Pool: #{p.title} saved"
      else
        puts "Pool: #{p.title} error - #{p.errors.to_a.first}"
      end  
    end

  else
    puts "Group: #{g.title} error - #{g.errors.to_a.first}"
  end      
end


# Super Admin & Admins
country = Country.first
bank    = Bank.where(title: 'Maybank').first

m = Member.new
m.country = country
m.bank = bank

m.account_holder_name = "Super Admin"
m.account_number = "0000-0000-0001"

m.username = "super"
m.email = "super@playkutu.com"
m.first_name = "Super"
m.last_name = "Admin"
m.phone_number = "+60123456789"
m.role = Member::Roles[:super_admin]

m.password = "password"
m.password_confirmation = "password"

if m.save
  m.confirm
  puts "Member: #{m.username} saved"
else
  puts "Member: #{m.username} error - #{m.errors.to_a.first}"
end

m = Member.new
m.country = country
m.bank = bank

m.account_holder_name = "Default Admin"
m.account_number = "0000-0000-0002"

m.username = "default"
m.email = "default@playkutu.com"
m.first_name = "Default"
m.last_name = "Admin"
m.phone_number = "+60123456780"
m.role = Member::Roles[:group_admin]

m.password = "password"
m.password_confirmation = "password"
m.groupement = Groupement.first

if m.save
  m.confirm
  puts "Member: #{m.username} saved"
else
  puts "Member: #{m.username} error - #{m.errors.to_a.first}"
end

m = Member.new
m.country = country
m.bank = bank

m.account_holder_name = "Second Admin"
m.account_number = "0000-0000-0003"

m.username = "second"
m.email = "second@playkutu.com"
m.first_name = "Second"
m.last_name = "Admin"
m.phone_number = "+60123456781"
m.role = Member::Roles[:group_admin]

m.password = "password"
m.password_confirmation = "password"
m.groupement = Groupement.last

if m.save
  m.confirm
  puts "Member: #{m.username} saved"
else
  puts "Member: #{m.username} error - #{m.errors.to_a.first}"
end
