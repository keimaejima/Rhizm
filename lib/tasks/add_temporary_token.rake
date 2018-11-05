namespace :add_temporary_token do
	desc "add_temporary_token"

	task :add => :environment do
    	users = User.all
    	begin
    	  	for user in users
    			TemporaryToken.find_by(user_id: user.id).update(token_amount: Settings.token_amount.monthly_add)
    		end
    	rescue => e
    	  Rails.logger.error("aborted task" + e)
    	  raise e
    	end
  	end
end
