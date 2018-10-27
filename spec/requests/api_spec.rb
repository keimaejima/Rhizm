require 'rails_helper'

user1_slack_id = 'UD6BH40821'
user2_slack_id = 'UD6BH40822'

describe 'トークン付与のテスト：TemporaryTokenを十分持っている場合' do
  before do
    user1 = User.create(
      slack_id: user1_slack_id
    )
    StableToken.create(user_id: user1.id, token_amount:100)
    TemporaryToken.create(user_id: user1.id, token_amount:100)
    user2 = User.create(
      slack_id: user2_slack_id
    )
    StableToken.create(user_id: user2.id, token_amount: 0)
    TemporaryToken.create(user_id: user2.id, token_amount: 0)
    @params = {
      'event' =>
      {
        'type' => 'reaction_added',
        'channel' => 'bot-test',
        'user' => user1_slack_id,
        'item_user' => user2_slack_id,
        'reaction' => Settings.token_stamp.fifty
      }
    }
  end
  it "user1からuser2にTemporaryTokenを50RIZ付与する" do
    post '/api/v1/slacks', params: @params
    expect(StableToken.find_by(user_id: User.find_by(slack_id: user1_slack_id).id).token_amount).to eq 100
    expect(TemporaryToken.find_by(user_id: User.find_by(slack_id: user1_slack_id).id).token_amount).to eq 50
    expect(StableToken.find_by(user_id: User.find_by(slack_id: user2_slack_id).id).token_amount).to eq 50
  end
end

describe 'トークン付与のテスト：TemporaryTokenが不十分で、StableTokenを持っている場合' do
  before do
    user1 = User.create(
      slack_id: user1_slack_id
    )
    StableToken.create(user_id: user1.id, token_amount:100)
    TemporaryToken.create(user_id: user1.id, token_amount:0)
    user2 = User.create(
      slack_id: user2_slack_id
    )
    StableToken.create(user_id: user2.id, token_amount: 0)
    TemporaryToken.create(user_id: user2.id, token_amount: 0)
    @params = {
      'event' =>
      {
        'type' => 'reaction_added',
        'channel' => 'bot-test',
        'user' => user1_slack_id,
        'item_user' => user2_slack_id,
        'reaction' => Settings.token_stamp.fifty
      }
    }
  end
  it "user1からuser2にTemporaryTokenを50RIZ付与する" do
    post '/api/v1/slacks', params: @params
    expect(StableToken.find_by(user_id: User.find_by(slack_id: user1_slack_id).id).token_amount).to eq 50
    expect(StableToken.find_by(user_id: User.find_by(slack_id: user2_slack_id).id).token_amount).to eq 50
  end
end

describe 'トークン付与のテスト：TemporaryTokenもStableTokenも不十分な場合' do
  before do
    user1 = User.create(
      slack_id: user1_slack_id
    )
    StableToken.create(user_id: user1.id, token_amount: 0)
    TemporaryToken.create(user_id: user1.id, token_amount: 0)
    user2 = User.create(
      slack_id: user2_slack_id
    )
    StableToken.create(user_id: user2.id, token_amount: 0)
    TemporaryToken.create(user_id: user2.id, token_amount: 0)
    @params = {
      'event' =>
      {
        'type' => 'reaction_added',
        'item' => {
          'channel' => 'bot-test'
          },
        'user' => user1_slack_id,
        'item_user' => user2_slack_id,
        'reaction' => Settings.token_stamp.fifty
      }
    }
  end
  it "user1からuser2にTemporaryTokenを50RIZ付与する" do
    post '/api/v1/slacks', params: @params
    expect(response.status).to eq 400
    expect(StableToken.find_by(user_id: User.find_by(slack_id: user1_slack_id).id).token_amount).to eq 0
    expect(StableToken.find_by(user_id: User.find_by(slack_id: user2_slack_id).id).token_amount).to eq 0
  end
end

describe 'トークン量確認まわりのテスト' do
	before do
    user = User.create(
      slack_id: user1_slack_id
      )
    StableToken.create(user_id: user.id, token_amount:10000)
    TemporaryToken.create(user_id: user.id, token_amount:150)
    @params = {
    	'event' =>
    	{
    		'type' => 'message',
    		'text' => '<@UDF39BHFY> hold',
    		'user' => user.slack_id,
    		'channel' => 'bot-test'
    	}
    }
  end
	it "持っている通貨の量を確認する" do
		post '/api/v1/slacks', params: @params
		expect(response.status).to eq 201
	end
end