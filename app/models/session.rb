# == Schema Information
#
# Table name: sessions
#
#  id                  :bigint(8)        not null, primary key
#  gender              :string           default("")
#  last_interaction_at :datetime
#  platform_name       :string           default("")
#  repeated            :boolean          default(FALSE)
#  session_type        :string           default("")
#  status              :integer(4)       default("incomplete")
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  district_id         :string
#  province_id         :string
#  session_id          :string           not null
#  source_id           :string           not null
#
class Session < ApplicationRecord
  include CsvConcern
  include Session::FilterableConcern

  enum status: %i[incomplete completed]

  PLATFORM_DICT = {
    ivr: :Verboice,
    chatbot: :Messenger
  }

  # TODO: reference session
  has_many :step_values, dependent: :destroy
  has_many :trackings, dependent: :destroy

  validates :session_id, :source_id, presence: true
  validates :platform_name, inclusion: {
                              in: %w(Messenger Telegram Verboice),
                              message: I18n.t("sessions.invalid_platform_name", value: "%{value}") }

  after_create_commit :completed!, if: :ivr?

  def self.create_or_return(platform_name, session_id)
    session = find_or_initialize_by(platform_name: platform_name, session_id: session_id, source_id: session_id)

    return session.clone if session.completed?

    session.last_interaction_at = Time.now
    session.save!
    session
  end

  def clone
    prev = last_completed_before(Time.now)
    return self unless prev.present?

    attrs = prev.attributes.slice(*clone_attributes)
    session = Session.create!(attrs.merge({ repeated: true }))
    session.clone_relations
  end

  def clone_relations
    step_values.clone_step :gender, gender
    step_values.clone_step :province, province_id
    step_values.clone_step :district, district_id
    self
  end

  def last_completed(time = created_at)
    Session.completed.where(platform_name: platform_name, session_id: session_id)\
                      .where("last_interaction_at <= ?", time)\
                      .find_by("province_id IS NOT NULL AND district_id IS NOT NULL AND gender != ''")
  end
  alias_method :last_completed_before, :last_completed

  def mask_session_id
    return md5_session_id if ivr?

    return session_id
  end

  def md5_session_id
    Digest::MD5.hexdigest session_id
  end

  def ivr?
    platform_name == "Verboice"
  end

  def self.accessed(options = {})
    variable = Variable.find_by(is_service_accessed: true)

    scope = filter(options)
    scope.where(step_values: variable.step_values) if variable.present?
  end

  def reachable_period?
    last_interaction_at > Setting.fb_reachable_period.days.ago
  end

  def self.user_count(params = {})
    scope = all
    scope = filter(scope, params)
    scope
  end

  def self.province_codes
    dashboard_query.province_codes
  end

  def self.province_ids
    pluck(:province_id).uniq - dump_codes
  end

  def self.district_ids
    pluck(:district_id).uniq - dump_codes
  end

  private

    def self.dump_codes
      ::Filters::LocationFilter.dump_codes
    end

    def self.dashboard_query
      dashboard_query = DashboardQuery.new
    end

    def clone_attributes
      %w(platform_name session_id source_id gender province_id district_id)
    end
end
