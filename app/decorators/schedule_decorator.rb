class ScheduleDecorator < ApplicationDecorator
  delegate_all

  def status
    enabled ? enabled_status : disabled_status
  end

  private

  def enabled_status
    h.tag.span h.t('schedules.enabled'), class: 'badge badge-pill badge-primary'
  end

  def disabled_status
    h.tag.span h.t('schedules.disabled'), class: 'badge badge-pill badge-danger'
  end
end
