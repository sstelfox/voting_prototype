require 'securerandom'

class Vote
  include DataMapper::Resource

  property :id,     Serial

  property :question_id,  Integer,  :unique_index => :qe_pair
  property :email,        String,   :length => 256, :required => true, :unique_index => :qe_pair
  property :pass,         String
  property :used,         Boolean,  :default => false

  belongs_to :question
  has n, :answers, :through => Resource

  before :save, :generate_pass

  def self.unused
    all(used: false)
  end

  def self.used
    all(used: true)
  end

  def answer!(answer_ids)
    update(used: true, answers: question.answers.all(id: answer_ids))
  end

  def generate_pass
    self.pass ||= SecureRandom.hex(8)
  end
end
