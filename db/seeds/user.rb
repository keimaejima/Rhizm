User.delete_all()
User.create(id: 0, slack_id: 'UD6BHH4HF')
User.create(id: 1, slack_id: 'UD9MWGVU7')
User.create(id: 2, slack_id: 'UD8JK44E6')
User.create(id: 3, slack_id: 'UDHUMQ7K3')

StableToken.delete_all()
StableToken.create(user_id:0, token_amount:10000)
StableToken.create(user_id:1, token_amount:5000)
StableToken.create(user_id:2, token_amount:4000)
StableToken.create(user_id:3, token_amount:3000)

TemporaryToken.delete_all()
TemporaryToken.create(user_id:0, token_amount:150)
TemporaryToken.create(user_id:1, token_amount:50)
TemporaryToken.create(user_id:2, token_amount:50)
TemporaryToken.create(user_id:3, token_amount:50)

