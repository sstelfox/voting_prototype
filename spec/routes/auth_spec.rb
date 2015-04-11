require 'spec_helper'

RSpec.describe(Voting::App) do
  context 'Authentication Routes', type: :rack do
    let(:user) { Fabricate(:user) }

    it 'provides a login page when logged out' do
      get('/login')
      expect(last_response).to be_ok
    end

    it 'redirects when the user is already logged in' do
      get('/login', {}, {'rack.session' => {user: user.id, ip: '127.0.0.1'}})
      follow_redirect!

      expect(last_response).to be_ok
      expect(last_request.path).to eq('/')

      expect(last_response.body).to match(/You're already logged in/)
    end

    it 'accepts a valid login' do
      post('/login', username: user.username, password: user.password)
      follow_redirect!

      expect(last_response).to be_ok
      expect(last_request.path).to eq('/')

      expect(last_response.body).to match(/successfully logged in/)
    end

    it 'rejects invalid logins' do
      post('/login', username: user.username, password: user.password.reverse)

      expect(last_response).to be_ok
      expect(last_request.path).to eq('/login')

      expect(last_response.body).to match(/Invalid login credentials/)
    end
  end
end
