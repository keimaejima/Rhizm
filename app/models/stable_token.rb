class StableToken < ApplicationRecord
	has_one :user, dependent: :destroy
end
