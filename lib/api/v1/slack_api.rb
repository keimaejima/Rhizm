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

     p params
     case params[:event][:type]
     when 'reaction_added'
       case params[:event][:reaction]
        #TODO:トークンの付与量によって分岐をつくる
      when Settings.token_stamp.fifty
        if params[:event][:user] == params[:event][:item_user]
          post_message(client, params[:event][:item][:channel], "<@#{params[:event][:user]}> さん 自分自身にトークンを渡すことはできません")
          error!('', 200)
        end
       begin
        present_user = User.find_by(slack_id: params[:event][:user])
        receive_user = User.find_by(slack_id: params[:event][:item_user])
          #プレゼンとするトークンの量によって分岐させる
          p_token_amount = 50
          t_token_amount = TemporaryToken.find_by(user_id: present_user.id).token_amount
          s_token_amount = StableToken.find_by(user_id: present_user.id).token_amount
          if t_token_amount >= p_token_amount
            TemporaryToken.where(user_id: present_user.id).update(token_amount: t_token_amount - p_token_amount)
            StableToken.where(user_id: receive_user.id).update(token_amount: StableToken.find_by(user_id: receive_user.id).token_amount + p_token_amount)
            PresentToken.create(
              present_user_id: present_user.user_id,
              receive_user_id: receive_user.user_id,
              token_amount_master_id: 0
              )
          elsif (t_token_amount + s_token_amount) >= p_token_amount
            TemporaryToken.where(user_id: present_user.id).update(token_amount: 0)
            StableToken.where(user_id: present_user.id).update(token_amount: s_token_amount - (p_token_amount - t_token_amount))
            StableToken.where(user_id: receive_user.id).update(token_amount: StableToken.find_by(user_id: receive_user.id).token_amount + p_token_amount)
            PresentToken.create(
              present_user_id: present_user.user_id,
              receive_user_id: receive_user.user_id,
              token_amount_master_id: 0
              )
          else
            post_message(client, params[:event][:item][:channel], 'RIZの残高が足りないようです')
            error!('Token amount is not enough', 400)
          end
          '200 OK'
          status 200
        rescue => e
          p e
          post_error(client, params[:event][:item][:channel])
          error!('Internal Server Error', 500)
       end
     end
   when 'message'
      #全メッセージを一旦保存
      begin
        Message.create(
          slack_id: params[:event][:user],
          text: params[:event][:text],
          channel_id: params[:event][:channel],
          team_id: params[:team_id]
          )
      rescue => e
          p e
      end

      if params[:event][:subtype] == Settings.slack_param.channel_join
         ##ユーザーがチームに新規参加
        begin
          User.create(slack_id: params[:event][:user])
        rescue => e
          post_error(client, Settings.channel_name.alert,'ユーザーの作成に失敗しました')
          error!('User create failure', 500)
        end
       else
        case params[:event][:text]
        when ranking
           ##RIZ所持数ランキング確認
           begin
             message = "【RIZ所持数ランキング】\n"
             stable_tokens = StableToken.order('token_amount DESC').limit(3)
             users = User.where('(id=?) or (id=?) or (id=?)', stable_tokens[0].user_id, stable_tokens[1].user_id, stable_tokens[2].user_id)
             users.each_with_index{|user, index|
               message += "#{index+1}位は <@#{user.slack_id}>さんで #{stable_tokens[index].token_amount} RIZ\n"
             }
             post_message(client, params[:event][:channel], message)
           rescue => e
             post_error(client, params[:event][:channel])
             error!('Internal Server Error', 500)
           end
         when hold
          ##個人のRIZ所持数確認
          begin
            user = User.find_by(slack_id: params[:event][:user])
            stable_riz = StableToken.find_by(user_id: user.id)
            temporary_riz = TemporaryToken.find_by(user_id: user.id)
            message = "<@#{params[:event][:user]}> さんは現時点で永続トークン：#{stable_riz.token_amount}RIZ、一時トークン：#{temporary_riz.token_amount}RIZ所持しています"
            post_message(client, params[:event][:channel], message)
          rescue => e
            post_error(client, params[:event][:channel])
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