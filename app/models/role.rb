# == Schema Information
#
# Table name: roles
#
#  id            :bigint(8)        not null, primary key
#  display_order :integer(4)       default(1)
#  name          :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Role < ApplicationRecord
  ROLE_NAMES = %w(site_ombudsman site_admin program_admin system_admin)

  default_scope { order(:display_order) }

  # associations
  has_many :users
  has_many :role_variables
  has_many :variables, through: :role_variables

  # validations
  validates :name, uniqueness: { case_sensitive: false }
  validates :name, inclusion: { in: ROLE_NAMES,
                                message: "%{value} is not a valid role name" }

  def position_level
    ROLE_NAMES.index name
  end

  def variable_names
    variables.pluck(:name)
  end

  ROLE_NAMES.each do |role_name|
    define_method "#{role_name}?".to_sym do
      role_name == name.sub(/\s/, "_")
    end
  end
end
