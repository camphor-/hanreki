require 'icalendar'
require 'hanreki/exceptions'
require 'hanreki/time_util'

# Event of CAMPHOR- Schedule
class Event
  using ExtendTime
  DOWS = %w(日 月 火 水 木 金 土)
  attr_accessor :filename, :line_number, :row
  attr_accessor :start, :end
  attr_accessor :public_summary, :private_summary
  attr_accessor :url

  def initialize(attributes)
    # Create assign methods for event attributes
    attributes.each do |attribute, v|
      send("#{attribute}=", v) if respond_to?("#{attribute}=")
    end if attributes
    yield self if block_given?
  end

  # マスターファイルの1行を読み込む処理
  # CSV を読む混む際にしかチェックできないバリデーションはここで行う.
  # その他のバリデーションは #validate で行う.
  # month: String (e.g. 201510)
  # line: CSV::Row
  # (eg. [01, 水, 15:00, 20:00, "HOUSE 開館", "HOUSE 当番 @ivstivs", https://camph.net])
  def self.from_master(filename, line_number, month, line)
    event = Event.new({
      row: line,
      filename: filename,
      line_number: line_number,
    })
    first_day = Date.parse("#{month}01")
    raise ValidationError.new(event), 'invalid number of columns' unless line.length == 7
    day, dow, hour_start, hour_end, public_summary, private_summary, url = line.fields.map { |c| c.to_s.strip }
    # Zero-fill (eg. 1 -> 01, 02 -> 02)
    day = day.rjust(2, "0")
    raise ValidationError.new(event), 'invalid day' unless day.length == 2
    raise ValidationError.new(event), 'invalid day' unless (first_day...first_day.next_month).include?(Date.parse("#{month}#{day}"))
    event.start = Time.parse("#{month}#{day} #{hour_start} +09:00").getlocal("+09:00")
    event.end = Time.parse("#{month}#{day} #{hour_end} +09:00").getlocal("+09:00")
    event.public_summary = public_summary unless public_summary.empty?
    event.private_summary = private_summary unless private_summary.empty?
    event.url = url unless url.empty?
    # 曜日はインスタンス変数に保持しないのでここでチェックする
    raise ValidationError.new(event), 'invalid day of the week' unless DOWS.include? dow
    raise ValidationError.new(event), 'invalid day of the week' unless DOWS[event.start.wday] == dow
    event.validate
    event
  end

  def to_h(type, time_type = :time)
    fail ValidationError.new(self), 'invalid type' unless [:public, :private].include?(type)
    fail ValidationError.new(self), 'invalid time_type' unless [:time, :string].include?(time_type)
    hash = {
      start: @start,
      end: @end,
      url: @url
    }
    case type
    when :public then hash[:title] = @public_summary
    when :private then hash[:title] = @private_summary
    end
    if time_type == :string
      hash[:start] = hash[:start].iso8601
      hash[:end] = hash[:end].iso8601
    end
    hash
  end

  # Format for master CSV files
  def to_master
    dow = DOWS[@start.wday]
    date_str = @start.strftime('%d')
    start_string = @start.strftime('%R')
    end_string =  @end.strftime('%R')
    [date_str, dow, start_string, end_string, @public_summary, @private_summary, @url]
  end

  def private?
    !@private_summary.nil?
  end

  def public?
    !@public_summary.nil?
  end

  # イベントのバリデーションを行う
  # バリデーションに成功した場合は true を返し, 失敗した場合は例外を送出する
  def validate
    raise ValidationError.new(self), 'invalid start & end' if @start > @end

    if @public_summary.nil? and @private_summary.nil?
      raise ValidationError.new(self), 'both summaries are not set'
    end

    if @public_summary == 'Open'
      if @start == @end
        raise ValidationError.new(self), '"open" event should have duration'
      end
    end

    if @private_summary == 'Closed'
      if not @public_summary.nil?
        raise ValidationError.new(self), 'invalid public summary for a closed event'
      end

      if not @start.is_midnight_in_jst
        raise ValidationError.new(self), 'start must be 0:00 for a closed event'
      end

      if not @end.is_midnight_in_jst
        raise ValidationError.new(self), 'end must be 0:00 for a closed event'
      end
    end

    unless @url.nil?
      unless @url.start_with?('http://') or @url.start_with?('https://')
        raise ValidationError.new(self), 'invalid url scheme'
      end
    end

    true
  end

  # Header for master CSV files
  def self.master_header
    %w(day day_of_week hour_start hour_end public_summary private_summary url)
  end

  def ==(other)
    self.class == other.class && self.state == other.state
  end

  protected

  def state
    [@start, @end, @public_summary, @private_summary, @url]
  end
end
