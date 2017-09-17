require 'date'
require 'thor'
require 'hanreki/exceptions'
require 'hanreki/schedule'
require 'hanreki/time_util'
require 'hanreki/version'

module Hanreki
  class CLI < Thor
    using ExtendTime

    desc 'blank --date [YYYYMM]', 'Generate a blank master file'
    method_option :date, type: :numeric
    def blank
      year, month = parse_month_in_options(options, Date.today.next_month)
      schedule = Schedule.initialize_for_month(year, month)
      raise 'file already exists' if schedule.master_file_exists?
      schedule.out_master
    end

    desc 'edit --date [YYYYMM]', 'Open a master file in the editor'
    method_option :date, type: :numeric
    def edit
      year, month = parse_month_in_options(options, Date.today)
      master_file = sprintf('master/%04d%02d.csv', year, month)
      raise 'file does not exist' unless File.exists? master_file

      editor = ENV['CAMPHOR_SCHEDULE_EDITOR'] || ENV['EDITOR'] || 'vi'
      system "#{editor} #{master_file}"
      validate
    end

    desc 'sync', 'Sync iCal and JSON'
    def sync
      schedule = load_schedule
      schedule.out_ical
      schedule.out_json
    end

    desc 'validate', 'Validate master files'
    def validate
      schedule = Schedule.new
      schedule = load_schedule
    end

    desc 'version', 'Show the version information'
    def version
      puts "hanreki v#{VERSION}"
    end
    map '--version' => :version

    private

    def load_schedule()
      schedule = Schedule.new
      begin
        schedule.load_master_files
      rescue ValidationError => e
        message = 'validation error'
        if e.event
          message += " at line #{e.event.line_number}" if e.event.line_number
          message += " in #{e.event.filename}" if e.event.filename
          message += "\n#{e.event.row.to_s.strip}" if e.event.row
        end
        message += "\n#{e}"
        puts message
        exit 1
      end
      schedule
    end

    # Parse a string (YYYYMM) in options[:date] and returns [YYYY, MM]
    def parse_month_in_options(options, default = nil)
      date = options[:date]
      if options[:date]
        begin
          Time.parse_month(options[:date].to_s)
        rescue ArgumentError => e
          raise "invalid date option: #{e.message}"
        end
      elsif default
        [default.year, default.month]
      end
    end
  end
end
