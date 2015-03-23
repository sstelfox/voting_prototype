require 'spec_helper'

RSpec.describe 'auth routes', :rack do
  it 'should provide a login page' do
    get '/login'
    expect(last_response).to be_ok
  end

  it 'should accept a valid login' do
    user = Fabricate(:user)
    post '/login', {username: user.username, password: user.password}
    expect(last_response.status).to eql(302)
  end
end
