# == Schema Information
#
# Table name: variables
#
#  id                  :bigint(8)        not null, primary key
#  is_location         :boolean
#  is_most_request     :boolean          default("false")
#  is_service_accessed :boolean          default("false")
#  is_ticket_tracking  :boolean          default("false")
#  is_user_visit       :boolean          default("false")
#  name                :string
#  report_enabled      :boolean          default("false")
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
class Variable < ApplicationRecord
  default_scope { order(name: :asc) }
  scope :except_done, -> { where.not(name: "done") }

  # associations
  has_many :step_values, dependent: :destroy
  has_many :role_variables, dependent: :destroy
  has_many :roles, through: :role_variables
  has_many :values, class_name: "VariableValue",
                    dependent: :destroy,
                    autosave: true

  # callbacks
  before_save :ensure_only_one_is_most_request
  before_save :ensure_only_one_is_user_visit
  before_save :ensure_only_one_is_service_accessed

  # validations
  validate :only_one_report_column
  validates :name, presence: true, uniqueness: true, format: { with: /\A[\w|\s|-]+\z/, message: I18n.t("variable.invalid_name") }
  validate :validate_unique_raw_value

  accepts_nested_attributes_for :values, allow_destroy: true, reject_if: :rejected_values

  delegate :site_setting, to: :site, prefix: false, allow_nil: true

  def to_partial_path
    "dictionaries/dictionary"
  end

  def feedback_message?
    report_enabled
  end

  def self.filter(params)
    scope = all
    scope = scope.where("name LIKE ?", "%#{params[:keyword]}%") if params[:keyword].present?
    scope
  end

  private
    def validate_unique_raw_value
      validate_uniqueness_of_in_memory(values, %i[raw_value], 'has already been taken')
    end

    def ensure_only_one_is_most_request
      return unless is_most_request_changed?
      sibling.update_all(is_most_request: false)
    end

    def ensure_only_one_is_user_visit
      return unless is_user_visit_changed?
      sibling.update_all(is_user_visit: false)
    end

    def ensure_only_one_is_service_accessed
      return unless is_service_accessed_changed?
      sibling.update_all(is_service_accessed: false)
    end

    def only_one_report_column
      errors.add(:report_enabled, I18n.t("variable.only_one_report_col")) if report_enabled? && report_already_set?
    end

    def report_already_set?
      sibling.exists?(report_enabled: true)
    end

    def sibling
      Variable.where.not(id: self)
    end

    def rejected_values(attributes)
      attributes["raw_value"].blank?
    end
end
