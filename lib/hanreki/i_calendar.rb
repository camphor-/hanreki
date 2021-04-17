require 'icalendar'
require 'hanreki/time_util'

# iCal
class ICalendar
  using ExtendTime
  def initialize(file = nil)
    @calendar = Icalendar::Calendar.new
    if file
      @calendar = Icalendar.parse(file).first
    else
      make_blank
    end
  end

  def to_s
    @calendar.publish
    @calendar.to_ical
  end

  def set_event(event, type)
    fail ValidationError.new(event), 'invalid date' unless event.start && event.end
    fail ValidationError.new(event), 'invalid type' unless [:public, :private].include?(type)
    @calendar.event do |e|
      e.dtstart = event.start
      e.dtend = event.end
      e.url = event.url
      case type
      when :public then e.summary = event.public_summary
      when :private then e.summary = event.private_summary
      end
    end
  end

  private

  # Generate new calendar
  def make_blank
    @calendar.append_custom_property('X-WR-CALNAME', 'CAMPHOR- Events')
    set_timezone
  end

  def set_timezone
    # TODO: Rewrite with tzinfo
    @calendar.timezone do |t|
      t.tzid = 'Asia/Tokyo'
      t.standard do |s|
        s.tzoffsetfrom = '+0900'
        s.tzoffsetto   = '+0900'
        s.tzname       = 'JST'
        s.dtstart      = '19700101T000000'
      end
    end
  end
end
