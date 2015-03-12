require 'spec_helper'

RSpec.describe 'auth routes', :rack do
  it 'should provide a login page' do
    get '/login'
    expect(last_response).to be_ok
  end
end
