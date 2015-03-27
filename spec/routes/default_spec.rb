require 'spec_helper'

RSpec.describe Voting::App, :type => :rack do
  it 'has a default route' do
    get '/'
    expect(last_response).to be_ok
  end
end
