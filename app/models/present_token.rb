# == Schema Information
#
# Table name: present_tokens
#
#  id               :bigint(8)        not null, primary key
#  present_token_id :integer
#  receive_user_id  :integer
#  present_user_id  :integer
#  token_amount     :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class PresentToken < ApplicationRecord
end
