class Comment < ActiveRecord::Base
  has_ancestry

  belongs_to :blog
  belongs_to :user

  validates :message, :blog_id, :user_id, presence: true

  before_save :set_upapproved_status, if: ->(comment) { comment.status.blank? }

  scope :approved_or_users_owned, ->(user) {where('user_id=? OR status=?', user.id, 'approved')}

  #  ===================
  #  = Instance metods =
  #  ===================

  def approved?
    status === 'approved'
  end

  #  =====================
  #  = Protected methods =
  #  =====================
  protected

    def set_upapproved_status
      self.status = 'unapproved'
    end

end

# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  message    :text
#  status     :string(255)
#  blog_id    :integer
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  ancestry   :string(255)
#
