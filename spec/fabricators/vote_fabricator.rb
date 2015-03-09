Fabricator(:vote, from: 'Voting::Vote') do
  email { Fake::Internet.email }
end
