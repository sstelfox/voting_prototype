module Voting
  class Question
    include DataMapper::Resource

    property :id,     Serial

    property :closed, Boolean, :default => false
    property :text,   String, :length => 256, :required => true

    has n, :answers
    has n, :votes

    def close_voting!
      update(closed: true)
    end

    def closed?
      closed
    end

    def possible_votes
      votes.count
    end

    def cast_votes
      votes.cast.count
    end

    def percentage_cast
      return 0.0 if possible_votes == 0
      cast_votes.to_f / possible_votes.to_f
    end
  end
end
