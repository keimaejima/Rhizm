require 'rails_helper'

describe "GET TEST" do
  it "tests" do
    get '/api/v1/slacks'
    expect(response.status).to eq 200
  end
end

describe 'トークンまわりのテスト' do
	before do
    @params = {
    	'event' =>
    	{
    		'type' => 'message',
    		'text' => '<@UDF39BHFY> hold',
    		'user' => 'UD6BHH4HF',
    		'channel' => 'bot-test'
    	}
    }
  end
	it "持っている通貨の量を確認する" do
		post '/api/v1/slacks', params: @params
		expect(response.status).to eq 200
	end
end