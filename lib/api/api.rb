class API < Grape::API
  prefix "api"
  version 'v1'
  format :json
  mount V1::Slack_API
end