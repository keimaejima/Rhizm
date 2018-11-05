# == Schema Information
#
# Table name: temporary_tokens
#
#  id                 :bigint(8)        not null, primary key
#  temporary_token_id :integer
#  user_id            :integer
#  token_amount       :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class TemporaryToken < ApplicationRecord
end
