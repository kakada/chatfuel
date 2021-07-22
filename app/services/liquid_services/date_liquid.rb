module LiquidServices
  class DateLiquid
    def to_h
      day, month, year = I18n.l(Date.today, format: :default).split
      { 'current_day' => day,
        'current_month' => month,
        'current_year' => year
      }
    end
  end
end
