require 'csv'
namespace :db do
  namespace :import do

    task all: [ :groupement, :pool, :member, :account, :transaction ]

    task groupement: :environment do
      csv = CSV.read(Rails.root.join("lib/tasks/db/groupement.csv"))
      csv.each_with_index do |c,i|
        unless i == 0
          g = Groupement.new
          g. title = "Default"
          g.id = c[0]
          g.activated_on_create = c[1]
          g.initial_accounts = c[10]
          g.maximum_accounts = c[7]
          g.accounts_added_on_success = c[2]
        
          if g.save
            puts "Groupement: #{g.title} saved"
          else
            puts "Groupement: #{g.title} error - #{g.errors.to_a.first}"
          end
        end
      end
    end

    task pool: :environment do
      csv = CSV.read(Rails.root.join("lib/tasks/db/pool.csv"))
      csv.each_with_index do |c,i|
        unless i == 0
          g = Pool.new
          g.id = c[0]
          g.groupement_id = c[6]
          g.title = c[2]
          g.amount = c[1]
          g.position = c[4]
          g.feeders_count = c[3]
          g.timeout = c[5]
        
          if g.save
            puts "Pool: #{g.title} saved"
          else
            puts "Pool: #{g.title} error - #{g.errors.to_a.first}"
          end
        end
      end
    end

    task member: :environment do
      csv = CSV.read(Rails.root.join("lib/tasks/db/member.csv"))
      csv.each_with_index do |c,i|
        unless i == 0
          g = Member.new
          g.id = c[0]
          g.username = c[10]
          g.account_holder_name = c[1]
          g.account_number = c[2].to_s
          g.first_name = c[6]
          g.last_name = c[7]
          g.phone_number = c[8]
          g.email = c[5]
          g.password = c[9]
          g.password_confirmation = c[9]
          g.referral_code = (i == 1) ? "OldKutu" : nil
          g.role = (i == 1) ? Member::Roles[:group_admin] : Member::Roles[:regular_member]
          g.referrer_code = "OldKutu"
          g.bank = Bank.where(title: c[3]).first
          g.country = Country.where(title: c[4]).first
          g.sms_notification = false
          g.email_notification = true
          g.accounts_limit = 1
          g.groupement = Groupement.first

          if !g.valid?(:phone_number)
            g.phone_number = "60000000000"
          end
        
          g.skip_referrer_code = true

          if g.save
            g.confirm
            puts "Member: #{g.username} saved"
          else
            puts "Member: #{g.username} error - #{g.role} #{g.referrer_code} - #{g.errors.to_a.first}"
          end
        end
      end
    end


    task account: :environment do
      csv = CSV.read(Rails.root.join("lib/tasks/db/account.csv"))
      csv.each_with_index do |c,i|
        unless i == 0
          g = Account.new
          g.id = c[0]
          g.groupement_id = c[6]
          g.member_id = c[10]
          g.pool_id = c[11]
          g.pool_order = c[12]
          g.has_finished = c[4]
          g.number_associations_left = c[7]
          g.kicked_out = c[5]
          g.action_available = c[1]
          g.super_user = c[8]
          g.admin_account = c[2]
          g.arrival_date = c[3]
          g.name = c[6]
        
          if g.save
            puts "Account: #{g.name} saved"
          else
            puts "Account: #{g.name} error - #{g.errors.to_a.first}"
          end
        end
      end
    end    

    task transaction: :environment do
      csv = CSV.read(Rails.root.join("lib/tasks/db/transaction.csv"))
      csv.each_with_index do |c,i|
        unless i == 0

          pool = case c[8].to_i
          when 1000 then Pool.where(amount: 1000).first
          when 2000 then Pool.where(amount: 2000).first
          when 4000 then Pool.where(amount: 4000).first
          end

          g = Transaction.new
          g.id = c[0]
          g.eater_id = c[2]
          g.feeder_id = c[4]
          g.completed_date = c[1]
          g.value = c[8]
          g.timeout = c[7].to_i
          g.failed = c[3]
          g.pool = pool
          g.disputed = false
          g.sender_receipt = nil
          g.admin_confirmed = true
          g.sender_confirmed = true
          g.receiver_confirmed = true
          g.created_at = c[1]
  
          if g.save
            puts "Transaction: #{g.id} saved"
          else
            puts "Transaction: #{g.id} error - #{g.errors.to_a.first}"
          end
        end
      end
    end


  end
end