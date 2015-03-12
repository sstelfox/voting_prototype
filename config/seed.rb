require 'securerandom'

module SeedHelpers
  def event(msg)
    printf("%-50.50s", msg)
  end

  def event_failed
    puts "[ Failed ]"
  end

  def event_success
    puts "[ Done ]"
  end
end

module UserCreator
  extend SeedHelpers

  DEFAULT_USER_NAME = 'admin'
  PASS_BYTE_STRENGH = 5

  def self.new_user
    Voting::User.new(
      username: DEFAULT_USER_NAME,
      password: password,
      password_confirmation: password
    )
  end

  def self.password
    @password ||= SecureRandom.hex(PASS_BYTE_STRENGH)
  end

  def self.run
    return if Voting::User.first(username: DEFAULT_USER_NAME)
    event('Creating default user (%s:%s)...' % [DEFAULT_USER_NAME, password])
    new_user.save ? event_success : event_failed
  end
end

UserCreator.run
