require 'spec_helper'

describe Time do
  using ExtendTime

  let(:time) {
    described_class.new(2015, 10, 20, 16, 38, 0, 0)
  }

  describe '#next_day' do
    context 'when argument is empty' do
      subject { time.next_day }
      it { is_expected.to eq Time.new(2015, 10, 21, 16, 38, 0, 0) }
    end

    context 'when argument is given' do
      subject { time.next_day 10 }
      it { is_expected.to eq Time.new(2015, 10, 30, 16, 38, 0, 0) }
    end
  end

  describe '#next_hour' do
    context 'when argument is empty' do
      subject { time.next_hour }
      it { is_expected.to eq Time.new(2015, 10, 20, 17, 38, 0, 0) }
    end

    context 'when argument is given' do
      subject { time.next_hour 10 }
      it { is_expected.to eq Time.new(2015, 10, 21, 2, 38, 0, 0) }
    end
  end

  describe '#is_midnight_in_jst' do
    context 'when time is midnight in JST (case 1)' do
      let (:time) { described_class.new(2015, 10, 1, 0, 0, 0, '+09:00') }
      subject { time.is_midnight_in_jst }
      it { is_expected.to be true }
    end

    context 'when time is midnight in JST (case 2)' do
      let (:time) { described_class.new(2015, 10, 1, 15, 0, 0, '+00:00') }
      subject { time.is_midnight_in_jst }
      it { is_expected.to be true }
    end

    context 'when time is not midnight in JST (case 1)' do
      let (:time) { described_class.new(2015, 10, 1, 1, 0, 0, '+09:00') }
      subject { time.is_midnight_in_jst }
      it { is_expected.to be false }
    end

    context 'when time is not midnight in JST (case 2)' do
      let (:time) { described_class.new(2015, 10, 1, 16, 0, 0, '+00:00') }
      subject { time.is_midnight_in_jst }
      it { is_expected.to be false }
    end
  end

  describe '.parse_month' do
    context 'a valid date string is given' do
      subject { Time.parse_month '201510' }
      it { is_expected.to eq [2015, 10] }
    end

    context 'an invalid date string is given' do
      subject { -> { Time.parse_month '201515' } }
      it { is_expected.to raise_error(ArgumentError) }
    end

    context 'a shorter date string is given' do
      subject { -> { Time.parse_month '20151' } }
      it { is_expected.to raise_error(ArgumentError) }
    end

    context 'a longer date string is given' do
      subject { -> { Time.parse_month '2015123' } }
      it { is_expected.to raise_error(ArgumentError) }
    end

    context 'a too big year is given' do
      subject { -> { Time.parse_month '234512' } }
      it { is_expected.to raise_error(ArgumentError) }
    end

    context 'a too small year is given' do
      subject { -> { Time.parse_month '123410' } }
      it { is_expected.to raise_error(ArgumentError) }
    end

    context 'a non-numeric string is given' do
      subject { -> { Time.parse_month '二千十五年十月' } }
      it { is_expected.to raise_error(ArgumentError) }
    end
  end
end
