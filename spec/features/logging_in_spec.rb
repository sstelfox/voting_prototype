require 'spec_helper'

RSpec.describe 'authentication system', :type => :feature do
  let(:user) { Fabricate(:user) }

  it 'allows a valid user to login' do
    visit '/login'

    within('#login') do
      fill_in 'Username', :with => user.username
      fill_in 'Password', :with => user.password
      click_button 'Login'
    end

    expect(page).to have_content("You've successfully logged in")
  end

  it 'prevents an invalid user from logging in' do
    visit '/login'

    within('#login') do
      fill_in 'Username', :with => user.username
      fill_in 'Password', :with => user.password.reverse
      click_button 'Login'
    end

    expect(page).to_not have_content("You've successfully logged in")
  end
end
