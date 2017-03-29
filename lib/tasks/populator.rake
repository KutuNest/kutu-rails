namespace :db do
  namespace :populate do

    task all: [ :groupement, :pool, :member, :account, :transaction ]

    task groupement: :environment do
      3.times do |i|
        g = Groupement.new
        g. title = "Groupement #{i+1}"
        g.activated_on_create = true
        g.initial_accounts = 2
        g.maximum_accounts = 100
        g.accounts_added_on_success = 2
        if g.save
          puts "Groupement: #{g.title} saved"
        else
          puts "Groupement: #{g.title} error - #{g.errors.to_a.first}"
        end
      end
    end

    task pool: :environment do
      Groupement.all.each_with_index do |g, i|
        3.times do |j|
          p = Pool.new
          p.groupement = g
          p.title = "Pool #{i}-#{j}"
          p.amount = (i+1) * 1000
          p.position = i
          p.feeders_count = 0
          p.timeout = 60*60*24*7
          if p.save
            puts "Pool: #{p.title} saved"
          else
            puts "Pool: #{p.title} error - #{p.errors.to_a.first}"
          end
        end
      end
    end

    task member: :environment do
      20.times do |i|
        country = Country.first
        banks   = Bank.all.to_a

        m = Member.new
        m.country = country
        m.bank = banks.sample

        m.account_holder_name = "Member#{i} Name"
        m.account_number = "6787-8888-0000-#{i+1}"

        m.username = "member#{i}"
        m.email = "member#{i}@email.com"
        m.first_name = "Member#{i}"
        m.last_name = "Name"
        m.phone_number = "+6012345678#{i}"
        m.role = Member::Roles[:regular_member]

        m.password = "password"

        if m.save
          m.confirm
          puts "Member: #{m.username} saved"
        else
          puts "Member: #{m.username} error - #{m.errors.to_a.first}"
        end
      end

      members = Member.limit(4).to_a
      # Super Admin
      member = members.pop
      member.role = Member::Roles[:super_admin]
      puts "Member: #{member.username} now super admin" if member.save

      # Group Admin
      Groupement.all.each_with_index do |g, i|
        g.default_member = members[i]
        g.default_member.role = Member::Roles[:group_admin]
        puts "Member: #{g.default_member.username} now group admin" if g.default_member.save
      end  

    end


    task account: :environment do
      groupements = Groupement.all
      Member.all.each_with_index do |m,i|
        groupement = groupements.sample
        (0..(rand(4))).to_a.each do |j|
          a = Account.new
          a.member = m
          a.name = "#{m.username}_#{j}"
          a.arrival_date = rand(10).days.from_now
          a.admin_account = [true, false].sample
          a.super_user = [true, false].sample
          a.action_available = a.super_user ? false : true
          a.kicked_out = false
          a.number_associations_left = 1
          a.groupement = groupement
          a.pool = groupement.pools.first
          if a.save
            puts "Account: #{a.name} saved"
          else
            puts "Account: #{a.name} error - #{a.errors.to_a.first}"
          end          
        end
      end
    end

    task transaction: :environment do
      Transaction.destroy_all
      Pool.all.each do |pool|
        pool.accounts.each_with_index do |a, i|
          t = Transaction.new
          t.eater  = pool.accounts.first
          t.feeder = a
          t.completed_date = nil
          t.sender_ack = false
          t.receiver_ack = false
          t.admin_confirmed = false
          t.timeout = DateTime.now + pool.timeout.to_i.seconds
          t.failed = false
          t.value = pool.amount
          t.sender_receipt = nil
          t.member = a.member
          if t.save
            puts "Transaction: #{t.id} saved"
          else
            puts "Transaction: #{t.id} error - #{t.errors.to_a.first}"
          end            
        end
      end
    end

  end
end