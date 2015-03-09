Fabricator(:vote, from: 'Voting::Vote') do
  email { Faker::Internet.email }
end
