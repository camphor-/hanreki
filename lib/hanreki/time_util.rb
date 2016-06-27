require 'time'

# Add some useful methods to Time, provided as refinement
module ExtendTime
  refine Time do
    SECONDS_OF_HOUR = 60 * 60
    SECONDS_OF_DAY = SECONDS_OF_HOUR * 24

    # n 日後の Time を返す
    def next_day(n = 1)
      self + (n * SECONDS_OF_DAY)
    end

    # n 時間後の Time を返す
    def next_hour(n = 1)
      self + (n * SECONDS_OF_HOUR)
    end

    # JST で 0:00 a.m. がどうかを返す
    def is_midnight_in_jst
      seconds_in_local = ((self.hour * 60) + self.min) * 60 + self.sec
      seconds_in_jst = seconds_in_local - self.utc_offset + 9 * 60 * 60
      seconds_in_jst % (24 * 60 * 60) == 0
    end
  end

  refine Time.singleton_class do
    # YYYYMM 形式の String をパースして [YYYY, MM] を返す
    # パースに失敗した場合は ArgumentError を送出する
    def parse_month(date)
      match = /^(\d{4})(\d{2})$/.match(date)
      raise ArgumentError, 'invalid date format' if match.nil?
      year, month = match.captures.map(&:to_i)
      raise ArgumentError, 'invalid year' unless (1970..2030).include? year
      raise ArgumentError, 'invalid month' unless (1..12).include? month
      [year, month]
    end
  end
end
