# == Schema Information
#
# Table name: variable_values
#
#  id                :bigint(8)        not null, primary key
#  hint              :string(255)      default("")
#  is_criteria       :boolean          default(FALSE)
#  mapping_value_en  :string           default("")
#  mapping_value_km  :string           default("")
#  raw_value         :string           not null
#  step_values_count :integer(4)       default(0)
#  type_of           :string           default("")
#  value_status      :string           default("acceptable")
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  variable_id       :bigint(8)        not null
#
# Indexes
#
#  index_variable_values_on_variable_id  (variable_id)
#
# Foreign Keys
#
#  fk_rails_...  (variable_id => variables.id)
#
class VariableValue < ApplicationRecord
  enum value_status: { like: "0", acceptable: "1", dislike: "2" }
  USER_FEEDBACK = 'user_feedback'

  # associations
  belongs_to :variable
  has_many :step_values, dependent: :destroy

  # validations
  validates :raw_value, presence: true
  default_scope -> { order(:mapping_value_en) }

  scope :distinct_values, -> (field = 'mapping_value_en') { select("DISTINCT ON (#{field}) #{field}, id, raw_value, mapping_value_km") }
  scope :exclude, -> (ids) { where.not(id: ids) }
  scope :display_ratings, -> { where(raw_value: %w(2 3 4)) }

  def self.criteria
    find_by(is_criteria: true)
  end

  # Callback
  before_destroy :ensure_destroyable!
  before_create :set_mapping_value_locale_based
  before_save :reset_sibling_criteria, if: [:is_criteria_changed?, :is_criteria?]

  def destroyable?
    step_values_count.zero? || raw_value.null_value?
  end

  def ticket_status
    return unless variable.is_ticket_tracking?

    ticket = Ticket.find_by(code: raw_value)

    ticket&.progress_status || "incorrect"
  end

  delegate :name, to: :variable, prefix: true
  delegate :feedback?, to: :variable, prefix: false
  delegate :district?, to: :variable, prefix: false
  delegate :province?, to: :variable, prefix: false

  def mapping_value
    send("mapping_value_#{I18n.locale}".to_sym)
  rescue
    send(:mapping_value)
  end

  def plain_values
    [raw_value, mapping_value_en, mapping_value_km].compact
  end

  def unset_criteria
    update_column(:is_criteria, false)
  end

  def kind_of_criteria?
    criteria_value = VariableValue.criteria
    return false if criteria_value.nil?

    mapping_value == criteria_value.mapping_value
  end

  def self.kind_of_criteria
    where("mapping_value_en=:mapping_value OR mapping_value_km=:mapping_value", mapping_value: criteria&.mapping_value)
  end

  def self.user_feedback
    find_by(type_of: USER_FEEDBACK)
  end

  def self.type_of_user_feedback
    return [] unless user_feedback
    where("mapping_value_en=:mapping_value OR mapping_value_km=:mapping_value", mapping_value: user_feedback.mapping_value)
  end

  private
    def ensure_destroyable!
      return if destroyable?

      errors.add(:base, I18n.t("deleted.fail"))
      throw :abort
    end

    def set_mapping_value_locale_based
      self.mapping_value_en = self.raw_value if self.mapping_value_en.blank?
      self.mapping_value_km = self.raw_value if self.mapping_value_km.blank?
    end

    def reset_sibling_criteria
      return if !sibling.criteria.present?

      sibling.criteria.unset_criteria
    end

    def sibling
      VariableValue.exclude(self.id)
    end
end
