require 'securerandom'

module Voting
  class Voter
    include DataMapper::Resource
    include NestedModelHelpers

    property :id,     Serial

    property :question_id,  Integer,  unique_index: :qe_pair
    property :email,        String,   length: 256,
                                      required: true,
                                      unique_index: :qe_pair
    property :token,        String
    property :vote_cast,    Boolean,  default: false

    belongs_to :question
    has n, :vas
    has n, :answers, through: :vas

    before :save, :generate_token

    after :create, :email_token

    def self.cast
      all(vote_cast: true)
    end

    def self.uncast
      all(vote_cast: false)
    end

    def answer!(answer_ids)
      fail(ArgumentError, 'Question is closed.') if question.closed?
      fail(ArgumentError, 'Question isn\'t released.') unless question.released?

      update(vote_cast: true, answers: question.answers.all(id: answer_ids))
    end

    def censored_email
      parts = email.split('@')

      domain = parts.pop
      user = parts.join('@')

      user[0..1] + ('*' * 12) + user[-2..-1] + '@' + domain
    end

    def email_token
      puts self.inspect
    end

    def generate_token
      self.token ||= SecureRandom.hex(24)
    end

    def vote_cast?
      vote_cast
    end
  end
end
