require 'spec_helper'

RSpec.describe Voting::Question do
  it { expect(subject).to have_property(:id) }
  it { expect(subject).to have_property(:closed) }
  it { expect(subject).to have_property(:text) }

  it { expect(subject).to have_many(:answers) }
  it { expect(subject).to have_many(:voters) }

  let(:inst) { Fabricate(:question) }

  context '#close_voting!' do
    it 'marks the voting as closed' do
      inst.closed = false

      expect { inst.close_voting! }
        .to change { inst.closed? }.from(false).to(true)
    end

    it 'does not affect closed questions' do
      inst.close_voting!
      expect { inst.close_voting! }.to_not change { inst.closed? }
    end
  end

  context '#closed?' do
    it 'returns true when the voting is closed' do
      inst.closed = true
      expect(inst).to be_closed
    end

    it 'returns false when the voting is open' do
      inst.closed = false
      expect(inst).to_not be_closed
    end
  end

  context '#possible_voters' do
    it 'returns the number of voters associated with the question' do
      cnt = rand(10) + 1
      question = Fabricate(:question) { voters(count: cnt) }
      expect(question.possible_voters).to eql(cnt)
    end
  end

  context '#cast_voters' do
    it 'returns the number of voters that have cast their vote' do
      cast_count = rand(5) + 1

      inst.voters += Fabricate.times(cast_count, :cast_voter, question: inst)
      inst.save

      expect(inst.cast_voters).to eql(cast_count)
    end
  end

  context '#percentage_cast' do
    it 'returns 0.0 when there are no possible votes' do
      ques = Fabricate(:question) { voters(count: 0) }
      expect(ques.percentage_cast).to eql(0.0)
    end

    it 'returns the correct percentage of cast votes' do
      cast_count = rand(10) + 1
      uncast_count = rand(10)
      total = cast_count + uncast_count

      ques = Fabricate(:question) { voters(count: uncast_count) }
      ques.voters += Fabricate.times(cast_count, :cast_voter, question: ques)

      expected_pcnt = (cast_count.to_f / total.to_f) * 100

      expect(ques.percentage_cast).to eql(expected_pcnt)
    end
  end

  context '#vote_breakdown' do
    it 'returns an array of answers with the number of votes they\'ve received'
    it 'sorts the array based on number of votes (descending)'
  end
end
