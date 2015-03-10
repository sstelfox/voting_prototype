require 'ipaddr'

class Voting::App
  get '/questions/?' do
    erb :'questions/index', :locals => {questions: Voting::Question.all}
  end

  get '/questions/new/?', :auth => nil do
    question = Voting::Question.new({
      answers: 3.times.map { Voting::Answer.new },
      voters: 3.times.map { Voting::Voter.new }
    })
    erb :'questions/new', :locals => {question: question}
  end

  post '/questions/new/?', :auth => nil do
    question = params[:question] || {}
    answer_attributes = question.delete('answer_attributes') || []
    voter_attributes = question.delete('voter_attributes') || []

    question = Voting::Question.new(question)
    question.answers = answer_attributes.map { |a| Voting::Answer.new(a) }
    question.voters = voter_attributes.map { |v| Voting::Voter.new(v) }

    if question.save
      flash[:success] = "You've successfully created a <a href='/questions/#{question.id}'>new question</a>."
      redirect '/questions'
    else
      flash[:error] = "There was an error in your submission."
      erb :'questions/new', :locals => {question: question}
    end
  end

  get '/questions/:id/?' do
    erb :'questions/show', :locals => {question: Voting::Question.get(params[:id])}
  end

  get '/questions/:id/close/?', :auth => nil do
    halt(404) unless (question = Voting::Question.get(params[:id]))

    question.close_voting!
    redirect "/questions/#{question.id}/"
  end

  get '/questions/:id/vote/:token/?' do
    halt(404) unless (question = Voting::Question.get(params[:id]))
    halt(403) unless (voter = question.voters.all(token: params[:token]).first)

    erb :'questions/vote', :locals => {question: question, voter: voter}
  end

  post '/questions/:question_id/vote/:token/?' do
    halt(404) unless (question = Voting::Question.get(params[:question_id]))
    halt(403) unless (voter = question.voters.all(token: params[:token]).first)

    if voter.answer!(params[:answer_ids].map(&:to_i))
      redirect "/questions/#{question.id}/vote/#{voter.token}/"
    else
      erb :'questions/vote', :locals => {question: question, voter: voter}
    end
  end
end
