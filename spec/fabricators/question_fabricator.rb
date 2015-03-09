Fabricator(:question, from: 'Voting::Question') do
  text { sequence(:question) { |i| "Question #{i}" } }

  answers(count: 10)
  votes(count: 20)
end
