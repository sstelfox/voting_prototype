module RackTestHelpers
  include Rack::Test::Methods

  def app
    Voting::App
  end
end
