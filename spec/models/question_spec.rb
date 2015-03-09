require 'spec_helper'

RSpec.describe Voting::Question do
  it { expect(subject).to have_property(:id) }
  it { expect(subject).to have_property(:closed) }
  it { expect(subject).to have_property(:text) }

  it { expect(subject).to have_many(:answers) }
  it { expect(subject).to have_many(:votes) }

  let(:inst) { Fabricate(:question) }

  context '#close_voting!' do
    it 'should mark the voting as closed' do
      inst.closed = false
      expect { inst.close_voting! }.to change { inst.closed? }.from(false).to(true)
    end

    it 'should not affect closed questions' do
      inst.close_voting!
      expect { inst.close_voting! }.to_not change { inst.closed? }
    end
  end

  context '#closed?' do
    it 'should return true when the voting is closed' do
      inst.closed = true
      expect(inst).to be_closed
    end

    it 'should return false when the voting is open' do
      inst.closed = false
      expect(inst).to_not be_closed
    end
  end

  context '#possible_votes' do
    it 'should return the number of votes associated with the question' do
      cnt = rand(10) + 1
      question = Fabricate(:question) { votes(count: cnt) }
      expect(question.possible_votes).to eql(cnt)
    end
  end

  context '#cast_votes' do
    it 'should return the number of votes that have been cast' do
      cast_count = rand(5) + 1

      inst.votes += Fabricate.times(cast_count, :cast_vote, question: inst)
      inst.save

      expect(inst.cast_votes).to eql(cast_count)
    end
  end

  context '#percentage_cast' do
    it 'should return 0.0 when there are no possible votes' do
      ques = Fabricate(:question) { votes(count: 0) }
      expect(ques.percentage_cast).to eql(0.0)
    end

    it 'should return the correct percentage of cast votes' do
      cast_count = rand(10) + 1
      uncast_count = rand(10)
      total = cast_count + uncast_count

      ques = Fabricate(:question) { votes(count: uncast_count) }
      ques.votes += Fabricate.times(cast_count, :cast_vote, question: ques)

      expected_pcnt = (cast_count.to_f / total.to_f)

      expect(ques.percentage_cast).to eql(expected_pcnt)
    end
  end
end
