module Voting
  class Question
    include DataMapper::Resource

    property :id,     Serial

    property :closed, Boolean, :default => false
    property :text,   String, :length => 256, :required => true

    has n, :answers
    has n, :voters

    validates_with_method :validate_answers
    validates_with_method :validate_voters

    def answer_attributes=(attrs)
      self.answers = Array(attrs).map do |a|
        answer = answers.get(a.delete(:id).to_i) || Voting::Answer.new(a)
        answer.attributes = a
        answer
      end
    end

    def cast_voters
      voters.cast.count
    end

    def close_voting!
      update(closed: true)
    end

    def closed?
      closed
    end

    def percentage_cast
      return 0.0 if possible_voters == 0
      (cast_voters.to_f / possible_voters.to_f) * 100
    end

    def possible_voters
      voters.count
    end

    def vote_breakdown
      answers.map { |a| [a, a.voters.count] }.sort_by { |_, cnt| -cnt }
    end

    def voter_attributes=(attrs)
      self.voters = Array(attrs).map do |v|
        voter = voters.get(v.delete(:id).to_i) || Voting::Voter.new(v)
        voter.attributes = v
        voter
      end
    end

    protected

    def validate_answers
      unless answers.map(&:valid?).all?
        return [false, 'One or more answers are invalid.']
      end
      true
    end

    def validate_voters
      unless voters.map(&:valid?).all?
        return [false, 'One or more voters are invalid.']
      end
      true
    end
  end
end
