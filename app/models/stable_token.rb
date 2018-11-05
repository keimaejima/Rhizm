# == Schema Information
#
# Table name: stable_tokens
#
#  id              :bigint(8)        not null, primary key
#  stable_token_id :integer
#  user_id         :integer
#  token_amount    :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class StableToken < ApplicationRecord
	belongs_to :user, dependent: :destroy
end
