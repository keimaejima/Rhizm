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
        status 200
        params[:challenge]
      else
        p params[:item_user]
        p params
        p headers
        Slack.configure do |config|
          config.token = 'xoxb-448815397236-457111391542-knTZKkJ4iyPi1rBhNQ6k3bak'
        end
        client = Slack::Web::Client.new
        client.auth_test
        client.web_client.chat_postMessage channel: '#bot-test', text: 'Hello World'
        p 'accessed'
        status 200
        '200 OK'
      end
    end
  end
end