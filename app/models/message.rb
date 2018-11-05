# == Schema Information
#
# Table name: messages
#
#  id         :bigint(8)        not null, primary key
#  slack_id   :string
#  text       :text
#  channel_id :string
#  team_id    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Message < ApplicationRecord
end
