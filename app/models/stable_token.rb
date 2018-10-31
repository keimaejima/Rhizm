class StableToken < ApplicationRecord
	belongs_to :user, dependent: :destroy
end
