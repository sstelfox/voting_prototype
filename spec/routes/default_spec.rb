require 'spec_helper'

RSpec.describe 'default routes' do
  include Rack::Test::Methods

  def app
    Voting::App
  end

  it 'should have a default route' do
    get '/'
    expect(last_response).to be_ok
  end
end
