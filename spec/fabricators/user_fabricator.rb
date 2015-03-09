Fabricator(:user, from: 'Voting::User') do
  username { Faker::Intenet.user_name }

  after_build do |user, _|
    user.password = user.password_confirmation = Faker::Internet.password
  end
end
