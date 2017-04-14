module Transactions
	module Status
		extend ActiveSupport::Concern

		def confirmed?
			(sender_confirmed? and receiver_confirmed?) and admin_confirmed?
		end

		def new_transaction?
			! confirmed?
		end

		def timeout_datetime
			(self.created_at + self.timeout.seconds).to_datetime
		end

		def timed_out?
		 	timeout_datetime > DateTime.now
		end

		def confirm!
			self.admin_confirmed = true
			self.disputed = false
			self.failed = false
			self.disputed = false
		end

		def fail!
			self.failed = true
			self.disputed = false
			self.admin_confirmed = false
			self.sender_confirmed = false
			self.receiver_confirmed = false
		end

		def sender_confirm!
			self.sender_confirmed = true
		end

		def receiver_confirm!
			self.receiver_confirmed = true
		end

		def dispute!
			self.disputed = true
			self.admin_confirmed = false
			self.failed = false
		end

		def status
			if confirmed?
			  "transaction completed"
			elsif disputed?
				"under dispute"
			elsif failed?
				"transaction failed"
			elsif sender_confirmed?
			  "sender confirmed"
			elsif receiver_confirmed?
			  "receiver confirmed"
			else
			  "new transaction"
			end
		end
	end
end