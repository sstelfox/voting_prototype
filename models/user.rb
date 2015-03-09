require 'scrypt'

class User
  include DataMapper::Resource

  property :id,           Serial

  property :username,     String, length: 255
  property :crypt_pass,   String, length: 96,  accessor: :protected
  property :salt,         String, length: 32,  accessor: :protected

  timestamps :at

  has n, :audit_logs

  validates_format_of     :username, with: /\w+/, message: 'Only letters, numbers, and underscores are allowed in a username.'
  validates_length_of     :username, min:  4,     message: 'A username needs to be at least 4 characters long.'
  validates_presence_of   :username,              message: 'We need a username so you can get back in later!'
  validates_uniqueness_of :username,              message: 'We already have an account with that username. Please pick another one.'

  # Ensure our usernames are case consistent
  before :save do |u|
    u.username.downcase!
  end

  # Password/Password confirmation virtual attributes, used for collection what
  # will become the crypt_pass & salt combo.
  attr_accessor :password, :password_confirmation
  validates_presence_of :password, if: lambda { |u| !(u.has_password?) }, message: 'Please provide a password for your account.'
  validates_confirmation_of :password, message: 'Passwords don\'t match!'

  # Authenticates a user with their password.
  #
  # @api public
  # @param [String] user
  # @param [String] pass
  # @return [User,Nil]
  def self.authenticate(user, pass)
    user = first(username: user.downcase)

    return nil if user.nil?
    return nil unless user.check_password(pass)

    user
  end

  # Check the user's password against the stored one and return whether or not
  # the password provided matches the stored salt and hash.
  #
  # @param [String] pass
  # @return [Boolean]
  def check_password(pass)
    hash = calc_hash(pass)

    return false if hash.nil?
    return crypt_pass == hash
  end

  # Returns whether or not there is already a password on the user's instance,
  # used as part of a conditional validator.
  #
  # @api public
  # @return [Boolean]
  def has_password?
    (!!crypt_pass && !!salt)
  end

  # Override password setting, this is a virtual attribute and never gets saved
  # directly. This however generates a new salt and caculates a new scrypt hash.
  #
  # @api public
  # @param [String] pass
  # @return [String]
  def password=(pass)
    @password = pass
    generate_salt
    self[:crypt_pass] = calc_hash(pass)
  end

  protected

  # Calculate a hash based on the stored user's salt and the provided password.
  #
  # @param [String] pass
  # @return [String]
  def calc_hash(pass)
    SCrypt::Engine.scrypt( pass, self[:salt], SCrypt::Engine.autodetect_cost(self[:salt]), 32).unpack('H*').first
  end

  # Set and generate a salt for use with SCrypt. The strength of any new
  # passwords can be adjusted by changing the parameters to the salt generator.
  #
  # @return [String]
  def generate_salt
    self[:salt] = SCrypt::Engine.generate_salt(max_time: 1.25)
  end
end

