module Filters
  class NamedNumber
    def self.call(number)
      case
      when number == 0 then 'Zero'
      when number == 1 then 'One'
      when number > 1 then 'Many'
      end
    end
  end
end
