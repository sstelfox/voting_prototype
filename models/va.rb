class Va
  include DataMapper::Resource

  property :answer_id, Integer, :key => true
  property :vote_id, Integer, :key => true

  belongs_to :answer
  belongs_to :vote
end
