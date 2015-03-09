Fabricator(:voter, class_name: 'Voting::Voter') do
  email { Faker::Internet.email }
end

Fabricator(:cast_voter, from: :voter) do
  vote_cast(true)

  after_create do |voter, _|
    answers = voter.question.answers

    voter.answers = answers.sample(rand(answers.count))
    voter.save
  end
end
