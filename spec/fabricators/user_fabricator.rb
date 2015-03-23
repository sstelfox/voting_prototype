Fabricator(:user, class_name: 'Voting::User') do
  username { Faker::Internet.user_name }

  after_build do |user, _|
    user.password = user.password_confirmation = Faker::Internet.password
  end
end
