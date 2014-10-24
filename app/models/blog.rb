class Blog < ActiveRecord::Base
  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "missing.jpg"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  attr_accessor :remove_image

  belongs_to :user
  has_many :comments

  before_create :set_publish_status

  scope :published, -> { where status: 'published' }

  #  ====================
  #  = Instance methods =
  #  ====================
  def is_published?
    status === 'published'
  end


  def is_draft?
    status === 'draft'
  end

  def is_pending?
    status === 'pending'
  end

  def publish
    update_attribute :status, 'published'
  end

  def remove_image=(value)
    self.image = nil if value == '1'
  end

  #  ===================
  #  = Private methods =
  #  ===================
  private

    def set_publish_status
      self.status = 'pending'
    end

end

# == Schema Information
#
# Table name: blogs
#
#  id                 :integer          not null, primary key
#  title              :string(255)
#  content            :text
#  status             :string(255)
#  user_id            :integer
#  created_at         :datetime
#  updated_at         :datetime
#  type               :string(255)
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#
