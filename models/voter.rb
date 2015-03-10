require 'securerandom'

module Voting
  class Voter
    include DataMapper::Resource

    property :id,     Serial

    property :question_id,  Integer,  :unique_index => :qe_pair
    property :email,        String,   :length => 256, :required => true, :unique_index => :qe_pair
    property :token,        String
    property :vote_cast,    Boolean,  :default => false

    belongs_to :question
    has n, :vas
    has n, :answers, :through => :vas

    before :save, :generate_token

    def self.uncast
      all(vote_cast: false)
    end

    def self.cast
      all(vote_cast: true)
    end

    def answer!(answer_ids)
      fail(ArgumentError, 'Can\'t vote on a closed question.') if question.closed?
      update(vote_cast: true, answers: question.answers.all(id: answer_ids))
    end

    def vote_cast?
      self.vote_cast
    end

    def generate_token
      self.token ||= SecureRandom.hex(24)
    end
  end
end
