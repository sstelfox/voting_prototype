Fabricator(:vote, class_name: 'Voting::Vote') do
  email { Faker::Internet.email }
end

Fabricator(:cast_vote, from: :vote) do
  cast(true)

  after_create do |vote, _|
    answers = vote.question.answers

    vote.answers = answers.sample(answers.count)
    vote.save
  end
end
