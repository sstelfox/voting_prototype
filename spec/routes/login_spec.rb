require 'spec_helper'

RSpec.describe 'authentication routes' do
  include Rack::Test::Methods

  def app
    Voting::App
  end

  context 'while logged in' do
  end

  context 'while logged out' do
  end
end
