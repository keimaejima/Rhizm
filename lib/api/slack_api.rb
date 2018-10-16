class Slack_API < Grape::API
  resource "slacks" do
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
      case params[:event][:type]
      when 'reaction_added'
        case params[:event][:reaction]
        when 'yum'
          p params
          present_user = User.find_by(slack_id: params[:event][:user])
          receive_user = User.find_by(slack_id: params[:event][:item_user])
          PresentToken.create(
            present_user_id: present_user.user_id,
            receive_user_id: receive_user.user_id,
            token_amount_master_id: 0
            )
        end
        Slack.configure do |config|
          config.token = ENV['SLACK_TOKEN']
        end
        client = Slack::Web::Client.new
        client.auth_test
        client.chat_postMessage(
          channel: '#bot-test',
          text: 'Hello World',
          s_user: true
        )
        status 200
        '200 OK'
      end
    end
  end
end