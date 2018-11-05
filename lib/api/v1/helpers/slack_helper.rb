module V1
	module Helpers
	    module SlackHelper
	        def post_error(client, channel_name)
	        	begin
	        		client.chat_postMessage(
	            		channel: channel_name,
	            		text: Settings.alert.something_wrong,
	            		s_user: true
	          		)
	          	rescue => e
	          		Rails.logger.fatal(Settings.alert.occured_in_api)
            		Rails.logger.fatal(e)
          		end
	        end

	        def post_message(client, channel_name, message)
	        	begin
	        		client.chat_postMessage(
	            		channel: channel_name,
	            		text: message,
	            		s_user: true
	          		)
	          	rescue => e
	          		Rails.logger.fatal(Settings.alert.occured_in_api)
            		Rails.logger.fatal(e)
          		end
	        end
	    end
	end
end