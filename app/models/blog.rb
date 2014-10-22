class Blog < ActiveRecord::Base
  belongs_to :user
  has_many :comments

  before_create :set_publish_status

  def is_publish?
    status === 'publish'
  end

  def is_draft?
    status === 'draft'
  end

  def is_pending?
    status === 'pending'
  end





private

  def set_publish_status
    self.status = 'pending'
  end



end

# == Schema Information
#
# Table name: blogs
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  content    :text
#  status     :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  type       :string(255)
#
