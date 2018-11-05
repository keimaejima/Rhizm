# == Schema Information
#
# Table name: users
#
#  id          :bigint(8)        not null, primary key
#  user_id     :integer
#  slack_id    :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  charge_flag :boolean
#

class User < ApplicationRecord
	has_one :stable_token, dependent: :destroy
end
