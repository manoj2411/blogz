class Comment < ActiveRecord::Base
  belongs_to :blog
end

# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  message    :text
#  status     :string(255)
#  blog_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  user       :reference
#
