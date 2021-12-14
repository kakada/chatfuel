# == Schema Information
#
# Table name: chatfuel_raw
#
#  acceptable_behavior     :string(255)
#  acceptable_delivery     :string(255)
#  acceptable_pricing      :string(255)
#  acceptable_provide_info :string(255)
#  acceptable_request_form :string(255)
#  acceptable_working_hour :string(255)
#  certify_docs            :string(255)
#  certify_docs_3          :string(255)
#  construction_1          :string(255)
#  construction_2          :string(255)
#  construction_3          :string(255)
#  dbs_btn1                :string(255)
#  dbs_btn1_2              :string(255)
#  dbs_btn1_3              :string(255)
#  dbs_btn2                :string(255)
#  dbs_btn22               :string(255)
#  dislike_behavior        :string(255)
#  dislike_delivery        :string(255)
#  dislike_pricing         :string(255)
#  dislike_provide_info    :string(255)
#  dislike_request_form    :string(255)
#  dislike_working_hour    :string(255)
#  district                :string(255)
#  feedback_acceptable     :string(255)
#  feedback_challenge      :string(255)
#  feedback_dislike        :string(255)
#  feedback_district       :string(255)
#  feedback_level          :string(255)
#  feedback_like           :string(255)
#  feedback_message        :text
#  feedback_province       :string(255)
#  feedback_q2             :string(255)
#  feedback_q3             :string(255)
#  feedback_rating         :string(255)
#  feedback_unit           :string(255)
#  landrefill_1            :string(255)
#  landrefill_2            :string(255)
#  landtitle_1             :string(255)
#  landtitle_2             :string(255)
#  landtitle_3             :string(255)
#  like_behavior           :string(255)
#  like_delivery           :string(255)
#  like_pricing            :string(255)
#  like_provide_info       :string(255)
#  like_request_form       :string(255)
#  like_working_hour       :string(255)
#  location                :string(255)
#  location_code           :string(255)
#  location_name           :string(255)
#  main_construction       :string(255)
#  main_dbs                :string(255)
#  main_landrefill         :string(255)
#  main_landtitle          :string(255)
#  main_menu               :string(255)
#  owso_info               :string(255)
#  province                :string(255)
#  public_transport        :string(255)
#  ticket_code             :string(255)
#  ticket_status           :string(255)
#  tracking_ticket         :string(255)
#  user_gender             :string(255)
#  chatfuel_user_id        :string(255)
#
class ChatfuelRaw < ApplicationRecord
  self.table_name = "chatfuel_raw"

  def has_feedback_location?
    [feedback_unit, feedback_province, feedback_district].all? &:present?
  end
end
