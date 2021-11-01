# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint(8)        not null, primary key
#  actived                :boolean
#  avatar                 :string
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  email                  :string           default(""), not null
#  encrypted_password     :string           default("")
#  first_name             :string
#  gender                 :string
#  invitation_accepted_at :datetime
#  invitation_created_at  :datetime
#  invitation_limit       :integer(4)
#  invitation_sent_at     :datetime
#  invitation_token       :string
#  invitations_count      :integer(4)       default(0)
#  invited_by_type        :string
#  mid                    :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  status                 :integer(4)       default("enable")
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  invited_by_id          :bigint(8)
#  role_id                :integer(4)
#  site_id                :bigint(8)
#
# Indexes
#
#  index_users_on_email                              (email) UNIQUE
#  index_users_on_invitation_token                   (invitation_token) UNIQUE
#  index_users_on_invited_by_id                      (invited_by_id)
#  index_users_on_invited_by_type_and_invited_by_id  (invited_by_type,invited_by_id)
#  index_users_on_reset_password_token               (reset_password_token) UNIQUE
#  index_users_on_role_id                            (role_id)
#  index_users_on_site_id                            (site_id)
#
# Foreign Keys
#
#  fk_rails_...  (role_id => roles.id)
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable
  mount_uploader :avatar, AvatarUploader

  enum status: %i[enable disable]

  devise :omniauthable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable,
         :invitable, invite_for: 1.week

  has_many :identities, dependent: :destroy
  belongs_to :site, optional: true
  belongs_to :role, optional: true

  delegate :system_admin?, :site_admin?, :program_admin?, :site_ombudsman?, to: :role, allow_nil: true
  delegate :name, :position_level, :variable_names, to: :role, prefix: true, allow_nil: true

  after_create :invite!, if: :accessable?

  def display_name
    email.split("@").first
  end

  def self.from_omniauth(auth)
    identity = Identity.where(provider: auth['provider'], token: auth['uid']).first
    user = identity.try(:user) || User.find_or_initialize_by(email: auth["info"][:email])

    unless user.persisted?
      user.password = Devise.friendly_token
      user.confirmed_at = Time.now
      user.save
      user.identities.create(provider: auth['provider'], token: auth['uid'])
    end

    user
  end

  def self.filter(params = {})
    scope = all
    scope = scope.where('email LIKE ?', "%#{params[:keyword].downcase}%") if params[:keyword].present?
    scope
  end

  private
  
  def accessable?
    actived? && role.present?
  end

  def password_required?
    false
  end

  def confirmation_required?
    false
  end
end
