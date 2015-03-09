Fabricator(:answer, class_name: 'Voting::Answer') do
  text { sequence(:answer) { |i| "Answer #{i}" } }
end
