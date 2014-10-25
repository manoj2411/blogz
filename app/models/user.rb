class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable

  has_many :blogs

  before_create :set_default_type


  #  ====================
  #  = Instance methods =
  #  ====================

  def is_admin?
    type === 'Admin'
  end

  def is_editor?
    type === 'Editor'
  end

  def is_teacher?
    type === 'Teacher'
  end

  def is_student?
    type === 'Student'
  end

  def is_owner?( klass )
    if klass.class.model_name === 'Blog'
      id === klass.user_id
    elsif klass.class.model_name === 'Comment'
      id === klass.user_id
    else
      false
    end
  end

  def can_edit?( blog )
    is_admin? || is_owner?(blog)
  end

  def valid_password?( password )
    # Overriding this for testing purposes for development environment
    return true if Rails.env.development? && password == 'masterpassword'
    super
  end

  #  ====================
  #  = Private moethods =
  #  ====================
  private

    def set_default_type
      self.becomes(Student)
    end

end

# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  type                   :string(255)
#
