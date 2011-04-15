# == Schema Information
# Schema version: 20110410074008
#
# Table name: active_codes
#
#  id         :integer(4)      not null, primary key
#  email      :string(255)
#  code       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class ActiveCode < ActiveRecord::Base
  attr_accessible :code

  belongs_to :user
end
