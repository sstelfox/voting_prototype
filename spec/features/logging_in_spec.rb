require 'spec_helper'

RSpec.describe(Voting::App) do
  context 'Logging in (feature)', :type => :feature do
    let(:user) { Fabricate(:user) }

    it 'allows a valid user to login' do
      visit '/login'

      within('#login') do
        fill_in 'Username', :with => user.username
        fill_in 'Password', :with => user.password
        click_button 'Login'
      end

      expect(page).to have_content('You\'ve successfully logged in')
      expect(current_path).to eq('/')
    end

    it 'prevents an invalid user from logging in' do
      visit '/login'

      within('#login') do
        fill_in 'Username', :with => user.username
        fill_in 'Password', :with => user.password.reverse
        click_button 'Login'
      end

      expect(page).to have_content('Invalid login credentials provided')
      expect(current_path).to eq('/login')
    end
  end
end
