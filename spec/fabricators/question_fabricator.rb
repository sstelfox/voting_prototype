Fabricator(:question, class_name: 'Voting::Question') do
  text { sequence(:question) { |i| "Question #{i}" } }

  answers(count: 10)
  votes(count: 20)
end
