require 'csv'
require 'spec_helper'

describe Event do
  let(:event) {
    described_class.new(
      start: Time.new(2015, 10, 1, 13, 0, 0, '+09:00'),
      end:   Time.new(2015, 10, 1, 17, 0, 0, '+09:00'),
      public_summary: 'Open',
      private_summary: '@ymyzk'
    )
  }

  describe '.from_master' do
    context 'when a line is correctly formatted (a day is zero-filled)' do
      let(:row) { CSV::Row.new([], ['01', '木', '15:00', '20:00', 'Open', '@ymyzk @tanishiking', 'https://camph.net']) }

      subject { described_class.from_master('201510', row) }

      it 'works' do
        expect(subject).to eq(described_class.new(
          start: Time.new(2015, 10, 1, 15, 0, 0, '+09:00'),
          end:   Time.new(2015, 10, 1, 20, 0, 0, '+09:00'),
          public_summary: 'Open',
          private_summary: '@ymyzk @tanishiking',
          url: 'https://camph.net'
        ))
      end
    end

    context 'when a line is correct format (a day is NOT zero-filled)' do
      let(:row) { CSV::Row.new([], ['1', '木', '15:00', '20:00', 'Open', '@ymyzk @tanishiking', 'https://camph.net']) }

      subject { described_class.from_master('201510', row) }

      it 'works' do
        expect(subject).to eq(described_class.new(
          start: Time.new(2015, 10, 1, 15, 0, 0, '+09:00'),
          end:   Time.new(2015, 10, 1, 20, 0, 0, '+09:00'),
          public_summary: 'Open',
          private_summary: '@ymyzk @tanishiking',
          url: 'https://camph.net'
        ))
      end
    end

    context 'when a line is correctly formatted (a private summary is empty)' do
      let(:row) { CSV::Row.new([], ['1', '木', '18:00', '20:00', 'Event', '', '']) }

      subject { described_class.from_master('201510', row) }

      it 'works' do
        expect(subject).to eq(described_class.new(
          start: Time.new(2015, 10, 1, 18, 0, 0, '+09:00'),
          end:   Time.new(2015, 10, 1, 20, 0, 0, '+09:00'),
          public_summary: 'Event',
          private_summary: nil,
          url: nil
        ))
      end
    end

    context 'when a line is correctly formatted (a public summary is empty)' do
      let(:row) { CSV::Row.new([], ['1', '木', '00:00', '00:00', '', 'Closed', '']) }

      subject { described_class.from_master('201510', row) }

      it 'works' do
        expect(subject).to eq(described_class.new(
          start: Time.new(2015, 10, 1, 00, 0, 0, '+09:00'),
          end:   Time.new(2015, 10, 1, 00, 0, 0, '+09:00'),
          public_summary: nil,
          private_summary: 'Closed',
          url: nil
        ))
      end
    end

    context 'when an invalid day is given' do
        let(:row) { CSV::Row.new([], ['100', '木', '15:00', '20:00', 'Open', '', 'https://camph.net']) }

        subject { -> { described_class.from_master('201510', row) } }

        it { is_expected.to raise_error ArgumentError }
    end

    context 'when another invalid day is given' do
      let(:row) { CSV::Row.new([], ['30', '木', '15:00', '20:00', 'Open', '', 'https://camph.net']) }

      subject { -> { described_class.from_master('201502', row) } }

      it { is_expected.to raise_error(ArgumentError) }
    end

    context 'when start > end' do
      let(:row) { CSV::Row.new([], ['100', '木', '15:00', '10:00', 'Open', '', 'https://camph.net']) }

      subject { -> { described_class.from_master('201510', row) } }

      it { is_expected.to raise_error(ArgumentError) }
    end

    context 'when a public_summary is not set' do
      let(:row) { CSV::Row.new([], ['15', '木', '15:00', '20:00', '', '@ymyzk @tanishiking', 'https://camph.net']) }

      subject { described_class.from_master('201510', row) }

      it 'works & public_summary is expected to be nil' do
        expect(subject).to eq(described_class.new(
          start: Time.new(2015, 10, 15, 15, 0, 0, '+09:00'),
          end:   Time.new(2015, 10, 15, 20, 0, 0, '+09:00'),
          public_summary: nil,
          private_summary: '@ymyzk @tanishiking',
          url: 'https://camph.net'
        ))
      end
    end

    context 'when a private_summary is not set' do
      let(:row) { CSV::Row.new([], ['1', '木', '15:00', '20:00', 'Open', '', 'https://camph.net']) }

      subject { described_class.from_master('201510', row) }

      it 'works & private_summary is expected to be nil' do
        expect(subject).to eq(described_class.new(
          start: Time.new(2015, 10, 1, 15, 0, 0, '+09:00'),
          end:   Time.new(2015, 10, 1, 20, 0, 0, '+09:00'),
          public_summary: 'Open',
          private_summary: nil,
          url: 'https://camph.net'
        ))
      end
    end

    context 'when a url is not set' do
      let(:row) { CSV::Row.new([], ['1', '木', '15:00', '20:00', 'Open', '@ryota-ka', '']) }

      subject { described_class.from_master('201510', row) }

      it 'works & url is expected to be nil' do
        expect(subject).to eq(described_class.new(
          start: Time.new(2015, 10, 1, 15, 0, 0, '+09:00'),
          end:   Time.new(2015, 10, 1, 20, 0, 0, '+09:00'),
          public_summary: 'Open',
          private_summary: '@ryota-ka',
          url: nil
        ))
      end
    end
  end

  describe '#to_h' do
    context 'when type is public' do
      subject { event.to_h :public }

      it 'returns a hash object which title is a public summary' do
        expect(subject).to eq({
          title: 'Open',
          start: Time.new(2015, 10, 1, 13, 0, 0, '+09:00'),
          end: Time.new(2015, 10, 1, 17, 0, 0, '+09:00'),
          url: nil
        })
      end
    end

    context 'when type is private' do
      subject { event.to_h :private }

      it 'returns a hash object which title is a private summary' do
        expect(subject).to eq({
          title: '@ymyzk',
          start: Time.new(2015, 10, 1, 13, 0, 0, '+09:00'),
          end: Time.new(2015, 10, 1, 17, 0, 0, '+09:00'),
          url: nil
        })
      end
    end

    context 'when type is unexpected one' do
      subject { -> { event.to_h :undefined } }

      it { is_expected.to raise_error(ArgumentError) }
    end

    context 'when time_type is string' do
      subject { event.to_h :public, :string }

      it 'returns a hash object which time format is ISO 8601' do
        expect(subject).to eq({
          title: 'Open',
          start: '2015-10-01T13:00:00+09:00',
          end: '2015-10-01T17:00:00+09:00',
          url: nil
        })
      end
    end
  end

  describe '#to_master' do
    subject { event.to_master }

    it { is_expected.to eq ['01', '木', '13:00', '17:00', 'Open', '@ymyzk', nil] }
  end

  describe '#public?' do
    subject { event }

    it { is_expected.to be_public }

    context 'when public summary is nil' do
      before { event.public_summary = nil }

      it { is_expected.not_to be_public }
    end
  end

  describe '#private?' do
    subject { event }

    it { is_expected.to be_private }

    context 'when private summary is nil' do
      before { event.private_summary = nil }

      it { is_expected.not_to be_private }
    end
  end

  describe '#validate' do
    context 'when attributes are valid' do
      subject { event.validate }

      it { is_expected.to be true }
    end

    context 'when both summaries are not set' do
      before do
        event.public_summary = nil
        event.private_summary = nil
      end

      subject { -> { event.validate } }

      it { is_expected.to raise_error(ArgumentError) }
    end

    context 'when private summary is "Closed"' do
      before do
        event.public_summary = nil
        event.private_summary = 'Closed'
      end

      context 'when start & end are 0:00' do
        before do
          event.start = Time.new(2015, 10, 2, 0, 0, 0, '+09:00')
          event.end = Time.new(2015, 10, 2, 0, 0, 0, '+09:00')
        end

        subject { event.validate }

        it { is_expected.to be true }
      end

      context 'when public summary is not empty' do
        before do
          event.public_summary = 'Open'
        end

        subject { -> { event.validate } }

        it { is_expected.to raise_error(ArgumentError) }
      end

      context 'when start is not 0:00' do
        before do
          event.start = Time.new(2015, 10, 1, 13, 0, 0, '+09:00')
          event.end = Time.new(2015, 10, 2, 0, 0, 0, '+09:00')
        end

        subject { -> { event.validate } }

        it { is_expected.to raise_error(ArgumentError) }
      end

      context 'when end is not 0:00' do
        before do
          event.start = Time.new(2015, 10, 1, 0, 0, 0, '+09:00')
          event.end = Time.new(2015, 10, 1, 13, 0, 0, '+09:00')
        end

        subject { -> { event.validate } }

        it { is_expected.to raise_error(ArgumentError) }
      end
    end

    context 'when a url scheme is not valid' do
      before { event.url = 'ftp://camph.net' }

      subject { -> { event.validate } }

      it { is_expected.to raise_error(ArgumentError) }
    end
  end
end
