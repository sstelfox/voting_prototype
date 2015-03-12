module Voting
  class Question
    include DataMapper::Resource

    property :id,     Serial

    property :closed, Boolean, :default => false
    property :text,   String, :length => 256, :required => true

    has n, :answers
    has n, :voters

    def close_voting!
      update(closed: true)
    end

    def closed?
      closed
    end

    def possible_voters
      voters.count
    end

    def cast_voters
      voters.cast.count
    end

    def percentage_cast
      return 0.0 if possible_voters == 0
      (cast_voters.to_f / possible_voters.to_f) * 100
    end

    def vote_breakdown
      answers.map { |a| [a, a.voters.count ] }.sort_by { |_, cnt| -cnt }
    end
  end
end
