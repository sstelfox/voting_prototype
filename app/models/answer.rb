module Voting
  class Answer
    include DataMapper::Resource

    property :id,     Serial
    property :text,   String, :length => 256, :required => true

    belongs_to :question

    has n, :vas
    has n, :voters, :through => :vas
  end
end
