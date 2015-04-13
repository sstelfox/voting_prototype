Fabricator(:question, class_name: 'Voting::Question') do
  text { sequence(:question) { |i| "Question #{i}?" } }
  released true

  answers(count: 3)
  voters(count: 5)
end
