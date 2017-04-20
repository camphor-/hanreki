require 'csv'
require 'date'
require 'json'
require 'hanreki/event'
require 'hanreki/i_calendar'
require 'hanreki/time_util'

# Schedule for CAMPHOR- HOUSE assignments and other events
class Schedule
  using ExtendTime
  ICAL_PUBLIC_PATH = 'ical/camphor_public_events.ics'
  ICAL_PRIVATE_PATH = 'ical/camphor_private_events.ics'
  JSON_PUBLIC_PATH = 'json/camphor_public_events.json'
  JSON_PRIVATE_PATH = 'json/camphor_private_events.json'
  JSONP_PUBLIC_PATH = 'jsonp/camphor_public_events.js'
  JSONP_PRIVATE_PATH = 'jsonp/camphor_private_events.js'

  def initialize
    # マスターファイルを生成する際のファイル名の決定に使用
    @first_day_of_month = nil
    @events = []
  end

  # 指定された月の初期割り当てを @events に設定する
  def self.initialize_for_month(year, month)
    schedule = Schedule.new
    schedule.send(:initialize_assignments, year, month)
    schedule
  end

  # マスターファイルを読み込んで @events に設定する
  def load_master_files
    @events = Dir.glob('master/*.csv').flat_map do |f|
      month = f.match(/master\/(\d+).csv/)[1]
      CSV.open(f, headers: true) do |csv|
        csv.map { |line| Event.from_master(month, line) }
      end
    end
  end

  # Output private and public iCal calendar files
  def out_ical
    File.open(ICAL_PUBLIC_PATH, 'w') do |f|
      ical = ICalendar.new
      public_events.each { |event| ical.set_event(event, :public) }
      f.write(ical)
    end
    File.open(ICAL_PRIVATE_PATH, 'w') do |f|
      ical = ICalendar.new
      private_events.each { |event| ical.set_event(event, :private) }
      f.write(ical)
    end
  end

  # Output private and public JSON calendar files
  def out_json
    File.open(JSON_PUBLIC_PATH, 'w') do |f|
      f.write(events_to_json(public_events, :public))
    end
    File.open(JSON_PRIVATE_PATH, 'w') do |f|
      f.write(events_to_json(private_events, :private))
    end
  end

  # Output private and public JSONP calendar files
  def out_jsonp(callback = 'callback')
    File.open(JSONP_PUBLIC_PATH, 'w') do |f|
      f.write("#{callback}(#{events_to_json(public_events, :public)});")
    end
    File.open(JSONP_PRIVATE_PATH, 'w') do |f|
      f.write("#{callback}(#{events_to_json(private_events, :private)});")
    end
  end

  # Output master file
  def out_master
    CSV.open(
      file_path, 'w',
      headers: Event.master_header, write_headers: true
    ) do |master_file|
      @events.each { |event| master_file << event.to_master }
    end
  end

  def master_file_exists?
    File.exists? file_path
  end

  private

  def file_path
    "master/#{@first_day_of_month.strftime('%Y%m')}.csv".freeze
  end

  def initialize_assignments(year, month)
    @first_day_of_month =
      begin
        Date.new(year, month, 1)
      rescue TypeError
        raise ArgumentError, 'Invalid year and month'
      end

    days = @first_day_of_month...@first_day_of_month.next_month
    @events = days.map { |day| default_assignment(day) }
  end

  def default_assignment(date)
    # Set timezone explicitly (DO NOT use date.to_time, it uses local timezone)
    time = Time.new(date.year, date.month, date.day, 0, 0, 0, '+09:00')
    Event.new(
      start: time,
      end: time.next_day(1),
      public_summary: '',
      private_summary: 'Closed')
  end

  def public_events
    @events.select(&:public?)
  end

  def private_events
    @events.select(&:private?)
  end

  def events_to_json(events, type)
    events.map { |event| event.to_h(type, :string) }.to_json
  end
end
