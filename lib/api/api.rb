class API < Grape::API
  prefix "api"
  format :json
  mount Slack_API
end