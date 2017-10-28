require 'spec_helper'

describe Schedule do
  let(:schedule) {
    described_class.new
  }

  describe '#default_assignment' do
    context 'Friday' do
      subject { schedule.send(:default_assignment, Date.new(2015, 10, 23)) }

      it 'Closed' do
        expect(subject).to eq(Event.new(
          start: Time.new(2015, 10, 23, 0, 0, 0, '+09:00'),
          end:   Time.new(2015, 10, 24, 0, 0, 0, '+09:00'),
          public_summary: '',
          private_summary: 'Closed',
        ))
      end
    end

    context 'Saturday' do
      subject { schedule.send(:default_assignment, Date.new(2015, 10, 24)) }

      it 'Closed' do
        expect(subject).to eq(Event.new(
          start: Time.new(2015, 10, 24, 0, 0, 0, '+09:00'),
          end:   Time.new(2015, 10, 25, 0, 0, 0, '+09:00'),
          public_summary: '',
          private_summary: 'Closed',
        ))
      end
    end

    context 'Sunday' do
      subject { schedule.send(:default_assignment, Date.new(2015, 10, 25)) }

      it 'Closed' do
        expect(subject).to eq(Event.new(
          start: Time.new(2015, 10, 25, 0, 0, 0, '+09:00'),
          end:   Time.new(2015, 10, 26, 0, 0, 0, '+09:00'),
          public_summary: '',
          private_summary: 'Closed',
        ))
      end
    end
  end

  describe '#sort_by_date!' do
    let(:event1) {
      Event.new(
        start: Time.new(2015, 10, 25, 0, 0, 0, '+09:00'),
        end:   Time.new(2015, 10, 26, 0, 0, 0, '+09:00'),
        public_summary: '',
        private_summary: 'Closed',
      )
    }

    let(:event2) {
      Event.new(
        start: Time.new(2015, 10, 26, 0, 0, 0, '+09:00'),
        end:   Time.new(2015, 10, 27, 0, 0, 0, '+09:00'),
        public_summary: 'Open',
        private_summary: '@ymyzk',
      )
    }

    context 'when events are out of order' do
      subject {
        schedule.instance_variable_set("@events", [event2, event1])
        schedule.sort_by_date!
        schedule.instance_variable_get("@events")
      }

      it 'events are sorted' do
        expect(subject).to eq([event1, event2])
      end
    end

    context 'when events are in order' do
      subject {
        schedule.instance_variable_set("@events", [event1, event2])
        schedule.sort_by_date!
        schedule.instance_variable_get("@events")
      }

      it 'events are sorted' do
        expect(subject).to eq([event1, event2])
      end
    end
  end
end
