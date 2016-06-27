require 'spec_helper'

describe Schedule do
  let(:schedule) {
    described_class.new
  }

  describe '#default_assignment' do
    context 'Friday' do
      subject { schedule.send(:default_assignment, Date.new(2015, 10, 23)) }

      it 'Open 15:00-20:00' do
        expect(subject).to eq(Event.new(
          start: Time.new(2015, 10, 23, 15, 0, 0, '+09:00'),
          end:   Time.new(2015, 10, 23, 20, 0, 0, '+09:00'),
          public_summary: 'Open',
          private_summary: '@',
        ))
      end
    end

    context 'Saturday' do
      subject { schedule.send(:default_assignment, Date.new(2015, 10, 24)) }

      it 'Open 13:00-20:00' do
        expect(subject).to eq(Event.new(
          start: Time.new(2015, 10, 24, 13, 0, 0, '+09:00'),
          end:   Time.new(2015, 10, 24, 20, 0, 0, '+09:00'),
          public_summary: 'Open',
          private_summary: '@',
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
end
