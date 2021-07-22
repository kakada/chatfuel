module LiquidServices
  class DateLiquid
    def initialize(start_date)
      @start_date = start_date
    end

    def to_h
      cur_day, cur_month, cur_year = format_date(Date.today)

      { 
        'current_day' => cur_day,
        'current_month' => cur_month,
        'current_year' => cur_year,
        'report_date' => I18n.t("schedules.report_date_html", cur_month: cur_month, start_date: start_date, end_date: cur_date)
      }
    end

    def format_date(date)
      I18n.l(date, format: :default).split
    end

    def start_date
      I18n.l(@start_date.to_date, format: :default)
    end

    def cur_date
      I18n.l(Date.today, format: :default)
    end
  end
end
