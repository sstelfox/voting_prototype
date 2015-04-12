module Voting
  class Question
    include DataMapper::Resource

    property :id,       Serial

    property :closed,   Boolean,  default: false
    property :released, Boolean,  default: false
    property :text,     String,   length: 256,
                                  required: true

    has n, :answers
    has n, :voters

    def answer_attributes=(attrs)
      self.answers = Array(attrs).map { |a| Answer.set_or_new(a) }.reject(&:nil?)
    end

    def cast_voters
      voters.cast.count
    end

    def close_voting!
      update(closed: true, released: true)
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

    def released?
      released
    end

    def release_for_voting!
      update(released: true)
    end

    def vote_breakdown
      answers.map { |a| [a, a.voters.count] }.sort_by { |_, cnt| -cnt }
    end

    def voter_attributes=(attrs)
      self.voters = Array(attrs).map { |v| Voter.set_or_new(v) }.reject(&:nil?)
    end
  end
end
