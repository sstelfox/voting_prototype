class Question
  include DataMapper::Resource

  property :id,     Serial
  property :text,   String, :length => 256, :required => true

  has n, :answers
  has n, :vas
  has n, :votes, :through => :vas

  def possible_votes
    votes.count
  end

  def taken_votes
    votes.used.count
  end

  def voted_percentage
    return 0.0 if possible_votes == 0
    taken_votes.to_f / possible_votes.to_f
  end

  def vote_breakdown
    votes.used.vas.aggregate(:answer_id, :all.count)
  end
end
