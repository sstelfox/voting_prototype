module Voting
  class Va
    include DataMapper::Resource

    property :answer_id, Integer, key: true
    property :voter_id, Integer,  key: true

    belongs_to :answer
    belongs_to :voter
  end
end
