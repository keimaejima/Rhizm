# == Schema Information
#
# Table name: token_amount_masters
#
#  id                     :bigint(8)        not null, primary key
#  token_amount_master_id :integer
#  token_amount           :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class TokenAmountMaster < ApplicationRecord
end
