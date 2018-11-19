module V1
class Slack_API < Grape::API
 resource "slacks" do

  #Slackクライアント初期化
  Slack.configure do |config|
     config.token = ENV['SLACK_TOKEN']
  end

  client = Slack::Web::Client.new
  client.auth_test

   helpers V1::Helpers::SlackHelper

   get do
     "get test"
   end
   # params do
   #   requires :challenge
   # end
   post do
    #TODO: 決済していないユーザーの時はボットで排除する機能実装
     unless params[:challenge].nil?
       error!(params[:challenge], 200)
     end

     bot_name = '<@UDF39BHFY> '
     ranking = bot_name + 'ranking'
     hold = bot_name + 'hold'

     case params[:event][:type]
     when 'reaction_added'
      #全リアクションを一旦保存
      begin
        
      rescue => e
          Rails.logger.fatal(Settings.alert.occured_in_api)
          Rails.logger.fatal(e)
          error!('Internal Server Error', 500)
      end
      case params[:event][:reaction]
        #TODO:トークンの付与量によって分岐をつくる
      when /(10*?|50*?)riz/
        if params[:event][:user] == params[:event][:item_user]
          post_message(client, params[:event][:item][:channel], "<@#{params[:event][:user]}> さん 自分自身にトークンを渡すことはできません")
          error!('', 200)
        end
       begin
        present_user = User.find_by(slack_id: params[:event][:user])
        receive_user = User.find_by(slack_id: params[:event][:item_user])
          #プレゼントするトークンの量によって分岐させる
          p_token_amount = params[:event][:reaction].delete("^0-9").to_i
          t_token_amount = TemporaryToken.find_by(user_id: present_user.id).token_amount
          s_token_amount = StableToken.find_by(user_id: present_user.id).token_amount
          if t_token_amount >= p_token_amount
            TemporaryToken.where(user_id: present_user.id).update(token_amount: t_token_amount - p_token_amount)
            StableToken.where(user_id: receive_user.id).update(token_amount: StableToken.find_by(user_id: receive_user.id).token_amount + p_token_amount)
            PresentToken.create(
              present_user_id: present_user.id,
              receive_user_id: receive_user.id,
              token_amount: p_token_amount
              )
          elsif (t_token_amount + s_token_amount) >= p_token_amount
            TemporaryToken.where(user_id: present_user.id).update(token_amount: 0)
            StableToken.where(user_id: present_user.id).update(token_amount: s_token_amount - (p_token_amount - t_token_amount))
            StableToken.where(user_id: receive_user.id).update(token_amount: StableToken.find_by(user_id: receive_user.id).token_amount + p_token_amount)
            PresentToken.create(
              present_user_id: present_user.id,
              receive_user_id: receive_user.id,
              token_amount: p_token_amount
              )
          else
            post_message(client, params[:event][:item][:channel], 'RIZの残高が足りないようです')
            error!('Token amount is not enough', 400)
          end
          '200 OK'
          status 200
        rescue => e
          post_error(client, params[:event][:item][:channel])
          Rails.logger.fatal(Settings.alert.occured_in_api)
          Rails.logger.fatal(e)
          error!('Internal Server Error', 500)
       end
     end
   when 'message'
      #全メッセージを一旦保存
      begin
        Message.create(
          user_id: params[:event][:user],
          text: params[:event][:text],
          channel_id: params[:event][:channel],
          team_id: params[:team_id]
          )
      rescue => e
          Rails.logger.fatal(Settings.alert.occured_in_api)
          Rails.logger.fatal(e)
          error!('Internal Server Error', 500)
      end

      if params[:event][:subtype] == Settings.slack_param.channel_join
         ##ユーザーがチームに新規参加
        begin
          User.create(slack_id: params[:event][:user], email: client.users_info(user: params[:event][:user]).user.profile.email)
        rescue => e
          post_error(client, Settings.channel_name.alert,'ユーザーの作成に失敗しました')
          Rails.logger.fatal(Settings.alert.occured_in_api)
          Rails.logger.fatal(e)
          error!('User create failure', 500)
        end
       else
        case params[:event][:text]
        when ranking
           ##RIZ所持数ランキング確認
           begin
             message = "【RIZ所持数ランキング】\n"
             stable_tokens = StableToken.order('token_amount DESC').limit(10)
             stable_tokens.each_with_index{|s, index|
               message += "#{index+1}位は <@#{s.user.slack_id}>さんで #{s.token_amount} RIZ\n"
             }
             message += "\n【RIZ受け取り総量ランキング】\n"
             present_tokens = PresentToken.limit(10).group(:receive_user_id).sum(:token_amount).sort_by{ |_, v| v }
             present_tokens.each_with_index do |(key,val), index|
              user = User.find_by(id: key)
              message += "#{index+1}位は <@#{user.slack_id}>さんで #{val} RIZ\n"
             end
             post_message(client, params[:event][:channel], message)
           rescue => e
             post_error(client, params[:event][:channel])
             Rails.logger.fatal(Settings.alert.occured_in_api)
             Rails.logger.fatal(e)
             error!('Internal Server Error', 500)
           end
         when hold
          ##個人のRIZ所持数確認
          begin
            user = User.find_by(slack_id: params[:event][:user])
            stable_riz = StableToken.find_by(user_id: user.id)
            temporary_riz = TemporaryToken.find_by(user_id: user.id)
            receive_amount = PresentToken.where(receive_user_id: user.id).sum(:token_amount)
            message = "<@#{params[:event][:user]}> さんは現時点で永続トークン：#{stable_riz.token_amount}RIZ、一時トークン：#{temporary_riz.token_amount}RIZ所持しています\nこれまで受け取ったトークンの総量：#{receive_amount}RIZです"
            post_message(client, params[:event][:channel], message)
          rescue => e
            post_error(client, params[:event][:channel])
            Rails.logger.fatal(Settings.alert.occured_in_api)
            Rails.logger.fatal(e)
            error!('Internal Server Error', 500)
          end

        else

        end
      end
    end
  end
end
end
end