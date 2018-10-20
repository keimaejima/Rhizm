module V1
	module Helpers
	    module SlackHelper
	        def post_error(client, channel_name)
	        	client.chat_postMessage(
	            channel: channel_name,
	            text: Settings.alert.something_wrong,
	            s_user: true
	          )
	        end
	    end
	end
end