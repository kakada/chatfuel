# == Schema Information
#
# Table name: sites
#
#  id                        :bigint(8)        not null, primary key
#  code                      :string           default("")
#  deleted_at                :datetime
#  lat                       :float
#  latest_generated_pdf_name :string
#  lng                       :float
#  name_en                   :string           not null
#  name_km                   :string
#  status                    :integer(4)       default("disable")
#  sync_status               :integer(4)
#  token                     :string           default("")
#  tracks_count              :integer(4)       default(0)
#  whitelist                 :text
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  province_id               :string
#
# Indexes
#
#  index_sites_on_deleted_at  (deleted_at)
#  index_sites_on_name_en     (name_en)
#
class Site < ApplicationRecord
  attr_accessor :file

  SITE_CODE_DIGIT_COUNT = 4

  # soft delete
  acts_as_paranoid

  enum status: %i[disable enable]
  enum sync_status: %i[failure success]

  # associations
  has_many :tracks, dependent: :destroy
  has_many :users
  has_many :feedbacks
  has_many :sync_logs

  # api
  has_many :tickets
  accepts_nested_attributes_for :tickets

  has_many :site_settings, dependent: :destroy

  # validations
  validates :name_en, presence: { message: I18n.t("presence") }
  validates :sync_status, inclusion: { in: sync_statuses.keys }, allow_nil: true
  validates :code, presence: { message: I18n.t("presence") }
  validates :code,  uniqueness: true,
                    allow_blank: true,
                    format: {
                      with: /\A\d{4}\z/,
                      message: I18n.t("site.invalid_code") }
  validates :token, presence: true, if: :persisted?
  validates :whitelist, presence: true, if: :persisted?
  validates :lat, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }, allow_blank: true
  validates :lng, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }, allow_blank: true
  validate :whitelist_format

  before_validation :generate_whitelist, on: :create
  before_create :generate_token
  before_create :assign_province_id

  def self.find_with_whitelist(token, ip)
    where(token: token, whitelist: '*').or(where('token = ? AND whitelist LIKE ?', token, "%#{ip}%")).first
  end

  def self.filter(params = {})
    scope = all
    scope = scope.where('LOWER(name_en) LIKE :name OR name_km LIKE :name OR code LIKE :code', name: "%#{params[:keyword].downcase}%", code: "#{params[:keyword].downcase}%") if params[:keyword].present?
    scope
  end

  def map_position?
    lat.present? && lng.present?
  end

  def map_url
    "https://www.google.com/maps/dir/current+location/#{lat},#{lng}"
  end

  def name_i18n
    send("name_#{I18n.locale}".to_sym)
  end

  def pumi_province
    Pumi::Province.find_by_id(province_id) if province_id
  end

  def name_param
    "#{name_en}-#{code}".parameterize.underscore
  end

  private
    def whitelist_format
      return true if whitelist == '*'

      valid = true
      whitelist.to_s.split(';').each do |ip|
        valid = !(IPAddr.new(ip.strip) rescue nil).nil?
        return errors.add(:whitelist, I18n.t("site.invalid_whitelist")) unless valid
      end

      valid
    end

    def generate_token
      begin
        self.token = SecureRandom.hex
      end while self.class.exists?(token: token)
    end

    def generate_whitelist
      self.whitelist ||= '*'
    end

    def assign_province_id
      self.province_id = code[0..1]
    end
end
