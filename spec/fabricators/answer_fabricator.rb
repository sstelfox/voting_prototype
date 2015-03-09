Fabricator(:answer, from: 'Voting::Answer') do
  text { sequence(:answer) { |i| "Answer #{i}" } }
end
