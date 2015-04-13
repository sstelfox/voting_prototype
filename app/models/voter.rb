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

    property :approved,     Boolean,  default: true
    property :email_sent,   Boolean,  default: false
    property :vote_cast,    Boolean,  default: false

    belongs_to :question
    has n, :vas
    has n, :answers, through: :vas

    before :save, :generate_token
    after :save, :email_token

    def self.cast
      all(vote_cast: true)
    end

    def self.uncast
      all(vote_cast: false)
    end

    def answer!(answer_ids)
      fail(ArgumentError, 'Must be approved to vote.') unless approved?
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
      return if email_sent? || !approved?
      update(email_sent: true)

      if ENV['RACK_ENV'] == 'production'
        Pony.mail(
          to: email,
          subject: 'Your Voting Token',
          html_body: "<html><body><p>The following link allows you to vote on the question '#{question.text}'. Once the question has been has been opened click on the following link and choose your answers. After voting you can use the link to validate your votes were recorded correctly.</p><p><a href='http://voting.stelfox.net/questions/#{question_id}/vote/#{token}/'>http://voting.stelfox.net/questions/#{question_id}/vote/#{token}/</a></body></html>"
        )
      elsif ENV['RACK_ENV'] == 'development'
        puts inspect
      end
    end

    def generate_token
      self.token ||= SecureRandom.hex(24)
    end
  end
end
