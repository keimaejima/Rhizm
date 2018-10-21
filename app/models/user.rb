class User < ApplicationRecord
	has_one :stable_token, dependent: :destroy
end
