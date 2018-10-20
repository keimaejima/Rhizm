module V1
 class Slack_API < Grape::API
   resource "slacks" do

     helpers V1::Helpers::SlackHelper

     Slack.configure do |config|
       config.token = ENV['SLACK_TOKEN']
     end

     # client_real = Slack::RealTime::Client.new

     # client_real.on :hello do
     #   puts "Successfully connected, welcome '#{client_real.self.name}' to the '#{client_real.team.name}' team at https://#{client_real.team.domain}.slack.com."
     # end
     # client_real.on :message do |data|
     #   case data.text
     #   when 'bot hi' then
     #     client_real.message channel: data.channel, text: "Hi <@#{data.user}>!"
     #   when '@rhizm-test 参加メンバーは？'
     #     allUser = User.all?
     #     client_real.message channel: data.channel, text: "Hi <@#{allUser}>!"
     #   when /^bot/ then
     #     client_real.message channel: data.channel, text: "Sorry <@#{data.user}>, what?"
     #   end
     # end
     # client_real.on :close do |_data|
     #   puts "Client is about to disconnect"
     # end
     # client_real.on :closed do |_data|
     #   puts "Client has disconnected successfully!"
     # end
     # client_real.start!

     helpers do

     end
     get do
       "get test"
     end
     # params do
     #   requires :challenge
     # end
     post do
       unless params[:challenge].nil?
         error!(params[:challenge], 200)
       end

       client = Slack::Web::Client.new
       client.auth_test

       bot_name = '<@UDF39BHFY> '
       ranking = bot_name + 'ranking'
       hold = bot_name + 'hold'
       channel_join = 'channel_join'

       p params
       case params[:event][:type]
       when 'reaction_added'
         case params[:event][:reaction]
         when 'yum'
           p params
           begin
             present_user = User.find_by(slack_id: params[:event][:user])
             receive_user = User.find_by(slack_id: params[:event][:item_user])
             PresentToken.create(
               present_user_id: present_user.user_id,
               receive_user_id: receive_user.user_id,
               token_amount_master_id: 0
               )
           rescue => e
             p e
             client.chat_postMessage(
               channel: params[:event][:item][:channel],
               text: Settings.alert.something_wrong,
               s_user: true
             )
           end
         end
       when 'message'
        if params[:event][:subtype] == channel_join
          ##ユーザーがチームに新規参加
          User.create(slack_id: params[:event][:user])
        else
          case params[:event][:text]
          when ranking
            ##RIZ所持数ランキング確認
            user_name = ''
            for user in User.all
              user_name+user.slack_id
            end
            client.chat_postMessage(
                channel: params[:event][:channel],
                text: user_name,
                s_user: true
              )
          when hold
            ##個人のRIZ所持数確認
            begin
              user = User.find_by(slack_id: params[:event][:user])
              riz = StableToken.find_by(user_id: user.user_id)
              message = "<@#{params[:event][:user]}> さんは現時点で#{riz.token_amount}RIZ所持しています"
              client.chat_postMessage(
                channel: params[:event][:channel],
                text: message,
                s_user: true
              )
            rescue => e
              p e
              client.chat_postMessage(
                channel: params[:event][:channel],
                text: Settings.alert.something_wrong,
                s_user: true
              )
            end
          end
        end
       end
     end
   end
 end
end