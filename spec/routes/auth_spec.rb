require 'spec_helper'

RSpec.describe(Voting::App) do
  context 'Authentication Routes', type: :rack do
    it 'provides a login page' do
      get('/login')
      expect(last_response).to be_ok
    end

    it 'accepts a valid login' do
      user = Fabricate(:user)
      post('/login', username: user.username, password: user.password)
      expect(last_response.status).to eql(302)
    end
  end
end
